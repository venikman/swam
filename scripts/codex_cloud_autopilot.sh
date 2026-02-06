#!/usr/bin/env bash
set -euo pipefail
export GIT_TERMINAL_PROMPT=0

usage() {
  cat <<'EOF'
Usage:
  scripts/codex_cloud_autopilot.sh \
    [--env ENV_ID] [--branch BRANCH] [--poll-secs N] [--max-runs N] \
    [--attempts N] [--usage-log PATH] [--backoff-base-secs N] [--backoff-max-secs N] [--no-precheck]

What it does:
  Loops:
    1) submit a Codex Cloud task ("resume" prompt)
    2) wait for it to become READY
    3) (optional) precheck diff paths + choose an attempt (fail-fast if it touches outside work/ or violates checkpoint invariants)
    4) apply the diff locally
    5) enforce guardrails (only work/ changes; exactly one new work/checkpoints/* file)
    6) commit + push to the remote branch

Notes:
  - Requires `codex` CLI + access to Codex Cloud.
  - By default, picks the remote default branch (origin/HEAD). Override with --branch.
  - Set env id via CODEX_CLOUD_ENV_ID or --env.
  - If you request best-of-N with --attempts > 1, the script will pick the first attempt whose diff passes guard
    prechecks, then apply that attempt.
  - Retries and backs off on likely usage/rate-limit errors instead of exiting immediately.
  - Writes a local JSONL usage ledger (one line per submitted task) if --usage-log is set. Recommended default is
    `work/usage_log.jsonl` (gitignored).
  - Stop the loop with Ctrl-C.

Examples:
  source .codex/local.env
  scripts/codex_cloud_autopilot.sh --max-runs 20
EOF
}

env_id="${CODEX_CLOUD_ENV_ID:-}"
branch=""
poll_secs="20"
max_runs="0" # 0 = unlimited
cloud_attempts="1"
usage_log_path="work/usage_log.jsonl"
backoff_base_secs="300"
backoff_max_secs="3600"
precheck_diff="1"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --env)
      [[ $# -ge 2 ]] || { echo "Error: --env requires a value" >&2; exit 2; }
      env_id="${2}"
      shift 2
      ;;
    --branch)
      [[ $# -ge 2 ]] || { echo "Error: --branch requires a value" >&2; exit 2; }
      branch="${2}"
      shift 2
      ;;
    --poll-secs)
      [[ $# -ge 2 ]] || { echo "Error: --poll-secs requires a value" >&2; exit 2; }
      poll_secs="${2}"
      shift 2
      ;;
    --max-runs)
      [[ $# -ge 2 ]] || { echo "Error: --max-runs requires a value" >&2; exit 2; }
      max_runs="${2}"
      shift 2
      ;;
    --attempts)
      [[ $# -ge 2 ]] || { echo "Error: --attempts requires a value" >&2; exit 2; }
      cloud_attempts="${2}"
      shift 2
      ;;
    --usage-log)
      [[ $# -ge 2 ]] || { echo "Error: --usage-log requires a value" >&2; exit 2; }
      usage_log_path="${2}"
      shift 2
      ;;
    --backoff-base-secs)
      [[ $# -ge 2 ]] || { echo "Error: --backoff-base-secs requires a value" >&2; exit 2; }
      backoff_base_secs="${2}"
      shift 2
      ;;
    --backoff-max-secs)
      [[ $# -ge 2 ]] || { echo "Error: --backoff-max-secs requires a value" >&2; exit 2; }
      backoff_max_secs="${2}"
      shift 2
      ;;
    --no-precheck)
      precheck_diff="0"
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage
      exit 2
      ;;
  esac
done

if [[ -z "${env_id}" ]]; then
  echo "Missing env id. Set CODEX_CLOUD_ENV_ID or pass --env <ENV_ID>." >&2
  exit 2
fi
if ! [[ "${poll_secs}" =~ ^[0-9]+$ ]] || (("${poll_secs}" < 1)); then
  echo "Invalid --poll-secs value: ${poll_secs}. Expected a positive integer." >&2
  exit 2
fi
if ! [[ "${max_runs}" =~ ^[0-9]+$ ]]; then
  echo "Invalid --max-runs value: ${max_runs}. Expected 0 (unlimited) or a positive integer." >&2
  exit 2
fi
if ! [[ "${cloud_attempts}" =~ ^[0-9]+$ ]] || (("${cloud_attempts}" < 1)); then
  echo "Invalid --attempts value: ${cloud_attempts}. Expected a positive integer." >&2
  exit 2
fi
if ! [[ "${backoff_base_secs}" =~ ^[0-9]+$ ]] || (("${backoff_base_secs}" < 1)); then
  echo "Invalid --backoff-base-secs value: ${backoff_base_secs}. Expected a positive integer." >&2
  exit 2
fi
if ! [[ "${backoff_max_secs}" =~ ^[0-9]+$ ]] || (("${backoff_max_secs}" < "${backoff_base_secs}")); then
  echo "Invalid --backoff-max-secs value: ${backoff_max_secs}. Expected an integer >= --backoff-base-secs (${backoff_base_secs})." >&2
  exit 2
fi

if ! command -v codex >/dev/null 2>&1; then
  echo "codex CLI not found on PATH. Install it, then retry." >&2
  exit 2
fi
if ! codex login status >/dev/null 2>&1; then
  echo "Not logged in to codex. Run: codex login" >&2
  exit 2
fi

repo_root="$(git rev-parse --show-toplevel 2>/dev/null || true)"
if [[ -z "${repo_root}" ]]; then
  echo "Not in a git repo (could not find repo root)." >&2
  exit 2
fi
cd "${repo_root}"

mkdir -p tmp
lock_dir="tmp/codex_cloud_autopilot.lock"
if ! mkdir "${lock_dir}" 2>/dev/null; then
  echo "Another autopilot appears to be running (lock exists: ${lock_dir})." >&2
  echo "If you're sure it's stale, delete the lock dir and retry." >&2
  exit 2
fi
printf '%s\n' "$$" >"${lock_dir}/pid"
trap 'rm -f "${lock_dir}/pid" 2>/dev/null || true; rmdir "${lock_dir}" 2>/dev/null || true' EXIT

if [[ -z "${branch}" ]]; then
  origin_head="$(git symbolic-ref -q --short refs/remotes/origin/HEAD 2>/dev/null || true)"
  if [[ -n "${origin_head}" ]]; then
    branch="${origin_head#origin/}"
  else
    branch="$(git rev-parse --abbrev-ref HEAD)"
  fi
fi

prompt_path="prompts/04_codex_cloud_resume_prompt.txt"
if [[ ! -f "${prompt_path}" ]]; then
  echo "Prompt file not found: ${prompt_path}" >&2
  exit 2
fi

utc_now() {
  date -u +"%Y-%m-%dT%H:%M:%SZ"
}

append_usage_log() {
  local task_id="${1}"
  local attempt="${2}"
  local result="${3}"
  local checkpoint_stamp="${4:-}"
  local commit_sha="${5:-}"

  if [[ -z "${usage_log_path}" ]]; then
    return 0
  fi

  mkdir -p "$(dirname "${usage_log_path}")"

  local ts
  ts="$(utc_now)"

  if [[ -z "${attempt}" ]]; then
    attempt="0"
  fi

  printf '{"ts":"%s","env_id":"%s","branch":"%s","run":%s,"task_id":"%s","attempt":%s,"result":"%s","checkpoint":"%s","commit":"%s"}\n' \
    "${ts}" "${env_id}" "${branch}" "${run_idx}" "${task_id}" "${attempt}" "${result}" "${checkpoint_stamp}" "${commit_sha}" \
    >>"${usage_log_path}" || true
}

is_retriable_text() {
  local text="${1}"
  printf '%s\n' "${text}" | grep -Eqi \
    '(usage limit|rate limit|too many requests|\\b429\\b|quota|try again later|temporarily unavailable|service unavailable|timeout|timed out|connection (reset|refused))'
}

backoff_secs="${backoff_base_secs}"
backoff_reset() {
  backoff_secs="${backoff_base_secs}"
}
backoff_sleep() {
  local reason="${1}"
  echo "Backing off for ${backoff_secs}s (${reason})..."
  sleep "${backoff_secs}"
  if (("${backoff_secs}" < "${backoff_max_secs}")); then
    backoff_secs=$((backoff_secs * 2))
    if (("${backoff_secs}" > "${backoff_max_secs}")); then
      backoff_secs="${backoff_max_secs}"
    fi
  fi
}

diff_paths_from_unified_diff() {
  # Output unique file paths from `diff --git a/... b/...` lines.
  awk '/^diff --git a\//{print $3; print $4}' \
    | sed -E 's|^[ab]/||' \
    | sort -u
}

precheck_unified_diff() {
  local diff_out="${1}"
  local attempt_label="${2}"

  local paths disallowed ckpt_paths ckpt_count ckpt_path
  paths="$(printf '%s\n' "${diff_out}" | diff_paths_from_unified_diff || true)"
  if [[ -z "${paths}" ]]; then
    echo "Precheck failed: empty diff or could not parse paths (attempt=${attempt_label})." >&2
    return 1
  fi

  disallowed="$(printf '%s\n' "${paths}" | grep -Ev '^work/' || true)"
  if [[ -n "${disallowed}" ]]; then
    echo "Precheck failed: diff touches paths outside work/ (attempt=${attempt_label}):" >&2
    printf '%s\n' "${disallowed}" >&2
    return 1
  fi

  if ! printf '%s\n' "${paths}" | grep -qx 'work/STATE.md'; then
    echo "Precheck failed: diff does not touch work/STATE.md (attempt=${attempt_label})." >&2
    return 1
  fi

  ckpt_paths="$(printf '%s\n' "${paths}" | grep -E '^work/checkpoints/[0-9]{8}-[0-9]{4}\.md$' || true)"
  ckpt_count="$(printf '%s\n' "${ckpt_paths}" | sed '/^$/d' | wc -l | tr -d ' ')"
  if [[ "${ckpt_count}" != "1" ]]; then
    echo "Precheck failed: expected exactly 1 checkpoint path in diff, found ${ckpt_count} (attempt=${attempt_label})." >&2
    printf '%s\n' "${ckpt_paths}" >&2
    return 1
  fi

  ckpt_path="$(printf '%s\n' "${ckpt_paths}" | sed '/^$/d' | head -n 1)"
  if [[ -e "${ckpt_path}" ]]; then
    echo "Precheck failed: checkpoint path already exists locally: ${ckpt_path} (attempt=${attempt_label})." >&2
    return 1
  fi

  return 0
}

select_attempt_to_apply() {
  local task_id="${1}"

  # If diff prechecks are disabled, let Codex Cloud choose the default diff/attempt.
  if [[ "${precheck_diff}" != "1" ]]; then
    printf '\n'
    return 0
  fi

  local attempt diff_out
  if (("${cloud_attempts}" <= 1)); then
    diff_out="$(codex cloud diff "${task_id}" 2>&1 || true)"
    if precheck_unified_diff "${diff_out}" "default"; then
      printf '\n'
      return 0
    fi
    return 1
  fi

  for attempt in $(seq 1 "${cloud_attempts}"); do
    diff_out="$(codex cloud diff --attempt "${attempt}" "${task_id}" 2>&1 || true)"
    if precheck_unified_diff "${diff_out}" "${attempt}"; then
      printf '%s\n' "${attempt}"
      return 0
    fi
  done

  return 1
}

run_idx=0
while :; do
  run_idx=$((run_idx + 1))
  if (("${max_runs}" != 0)) && (("${run_idx}" > "${max_runs}")); then
    echo "Reached --max-runs=${max_runs}. Stopping."
    exit 0
  fi

  # Keep the workspace clean for reliable patch application.
  rm -f error.log || true
  if [[ -n "$(git status --porcelain)" ]]; then
    echo "Working tree is not clean. Commit/stash changes first, then retry." >&2
    git status --porcelain >&2
    exit 2
  fi

  git fetch origin "${branch}" >/dev/null 2>&1 || true
  if git show-ref --verify --quiet "refs/heads/${branch}"; then
    git checkout "${branch}"
  elif git rev-parse --verify "origin/${branch}" >/dev/null 2>&1; then
    git checkout -b "${branch}" --track "origin/${branch}"
  else
    echo "Remote branch not found: origin/${branch}" >&2
    exit 2
  fi
  git pull --ff-only

  query="$(cat "${prompt_path}")"
  echo
  echo "=== Run ${run_idx} ==="
  echo "Submitting Codex Cloud task (env=${env_id}, branch=${branch}, attempts=${cloud_attempts})..."
  task_url=""
  task_id=""
  out=""
  while :; do
    out="$(codex cloud exec --env "${env_id}" --branch "${branch}" --attempts "${cloud_attempts}" "${query}" 2>&1 || true)"
    task_url="$(
      printf '%s\n' "${out}" \
        | tr -d '\r' \
        | grep -Eo 'https://(chatgpt\.com|chat\.openai\.com)/codex/tasks/[^[:space:]]+' \
        | tail -n 1 \
        || true
    )"

    if [[ -n "${task_url}" ]]; then
      task_id="${task_url##*/}"
      backoff_reset
      break
    fi

    # Fallback: some versions/terminals may print only the task id, or wrap the URL.
    task_id="$(
      printf '%s\n' "${out}" \
        | tr -d '\r' \
        | grep -Eo 'task_[[:alnum:]_]+' \
        | tail -n 1 \
        || true
    )"
    if [[ -n "${task_id}" ]]; then
      task_url="https://chatgpt.com/codex/tasks/${task_id}"
      backoff_reset
      break
    fi

    if is_retriable_text "${out}"; then
      echo "Task submission failed (likely usage/rate limit). Will retry."
      backoff_sleep "submit"
      continue
    fi

    echo "Failed to submit task (no task URL found). Output:" >&2
    echo "${out}" >&2
    exit 2
  done

  echo "Task: ${task_url}"

  echo "Waiting for READY..."
  while :; do
    status_out="$(codex cloud status "${task_id}" 2>&1 || true)"
    if printf '%s' "${status_out}" | grep -q "\\[READY\\]"; then
      break
    fi
    if printf '%s' "${status_out}" | grep -q "\\[FAILED\\]\\|\\[CANCELED\\]\\|\\[CANCELLED\\]"; then
      echo "Task did not complete successfully:" >&2
      echo "${status_out}" >&2
      append_usage_log "${task_id}" "" "task_failed" "" ""
      if is_retriable_text "${status_out}"; then
        backoff_sleep "task_failed"
        continue 2
      fi
      exit 2
    fi
    if is_retriable_text "${status_out}"; then
      backoff_sleep "status"
      continue
    fi
    sleep "${poll_secs}"
  done

  attempt_to_apply=""
  if ! attempt_to_apply="$(select_attempt_to_apply "${task_id}")"; then
    echo "Failed to find an attempt whose diff passes prechecks for task ${task_id}." >&2
    append_usage_log "${task_id}" "" "precheck_failed" "" ""
    exit 2
  fi

  if [[ -n "${attempt_to_apply}" ]]; then
    echo "Selected attempt ${attempt_to_apply} for task ${task_id}."
  fi

  # Apply changes from the cloud task.
  if [[ -n "${attempt_to_apply}" ]]; then
    if ! codex cloud apply --attempt "${attempt_to_apply}" "${task_id}"; then
      echo "Failed to apply cloud diff for task ${task_id} (attempt ${attempt_to_apply})." >&2
      append_usage_log "${task_id}" "${attempt_to_apply}" "apply_failed" "" ""
      exit 2
    fi
  else
    if ! codex cloud apply "${task_id}"; then
      echo "Failed to apply cloud diff for task ${task_id}." >&2
      append_usage_log "${task_id}" "" "apply_failed" "" ""
      exit 2
    fi
  fi

  # Guardrails: only allow `work/` changes, and enforce exactly one new checkpoint file.
  status_lines="$(git status --porcelain)"
  if [[ -z "${status_lines}" ]]; then
    echo "No local changes after apply; stopping."
    exit 0
  fi

  changed_paths="$(printf '%s\n' "${status_lines}" | awk '{print $2}')"
  disallowed="$(printf '%s\n' "${changed_paths}" | grep -Ev '^(work/)' || true)"
  if [[ -n "${disallowed}" ]]; then
    echo "Refusing to commit: changes outside work/ detected:" >&2
    printf '%s\n' "${disallowed}" >&2
    append_usage_log "${task_id}" "${attempt_to_apply}" "guard_outside_work" "" ""
    exit 2
  fi

  new_checkpoint_files="$(printf '%s\n' "${status_lines}" | awk '$1=="??"{print $2}' | grep -E '^work/checkpoints/[0-9]{8}-[0-9]{4}\.md$' || true)"
  checkpoint_count="$(printf '%s\n' "${new_checkpoint_files}" | sed '/^$/d' | wc -l | tr -d ' ')"
  if [[ "${checkpoint_count}" != "1" ]]; then
    echo "Refusing to commit: expected exactly 1 new checkpoint file, found ${checkpoint_count}." >&2
    printf '%s\n' "${new_checkpoint_files}" >&2
    append_usage_log "${task_id}" "${attempt_to_apply}" "guard_checkpoint_count" "" ""
    exit 2
  fi

  checkpoint_file="$(printf '%s\n' "${new_checkpoint_files}" | head -n 1)"
  checkpoint_stamp="${checkpoint_file##*/}"
  checkpoint_stamp="${checkpoint_stamp%.md}"

  if ! printf '%s\n' "${changed_paths}" | grep -qx 'work/STATE.md'; then
    echo "Refusing to commit: expected work/STATE.md to be modified." >&2
    append_usage_log "${task_id}" "${attempt_to_apply}" "guard_missing_state" "${checkpoint_stamp}" ""
    exit 2
  fi

  git add work/
  if [[ -n "${attempt_to_apply}" ]]; then
    git commit -m "checkpoint: ${checkpoint_stamp} (${task_id}, attempt ${attempt_to_apply})"
  else
    git commit -m "checkpoint: ${checkpoint_stamp} (${task_id})"
  fi
  git push origin "${branch}"

  commit_sha="$(git rev-parse HEAD 2>/dev/null || true)"
  append_usage_log "${task_id}" "${attempt_to_apply}" "pushed" "${checkpoint_stamp}" "${commit_sha}"
done
