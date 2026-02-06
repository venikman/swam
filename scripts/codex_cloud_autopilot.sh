#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  scripts/codex_cloud_autopilot.sh [--env ENV_ID] [--branch BRANCH] [--poll-secs N] [--max-runs N]

What it does:
  Loops:
    1) submit a Codex Cloud task ("resume" prompt)
    2) wait for it to become READY
    3) apply the diff locally
    4) enforce guardrails (only work/ changes; exactly one new work/checkpoints/* file)
    5) commit + push to the remote branch

Notes:
  - Requires `codex` CLI + access to Codex Cloud.
  - By default, picks the remote default branch (origin/HEAD). Override with --branch.
  - Set env id via CODEX_CLOUD_ENV_ID or --env.
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

if ! command -v codex >/dev/null 2>&1; then
  echo "codex CLI not found on PATH. Install it, then retry." >&2
  exit 2
fi

repo_root="$(git rev-parse --show-toplevel 2>/dev/null || true)"
if [[ -z "${repo_root}" ]]; then
  echo "Not in a git repo (could not find repo root)." >&2
  exit 2
fi
cd "${repo_root}"

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
  git checkout "${branch}" >/dev/null 2>&1 || true
  git pull --ff-only origin "${branch}"

  query="$(cat "${prompt_path}")"
  echo
  echo "=== Run ${run_idx} ==="
  echo "Submitting Codex Cloud task (env=${env_id}, branch=${branch})..."
  out="$(codex cloud exec --env "${env_id}" --branch "${branch}" "${query}" 2>&1 || true)"
  task_url="$(printf '%s\n' "${out}" | grep -Eo 'https://chatgpt\\.com/codex/tasks/[^[:space:]]+' | tail -n 1 || true)"
  if [[ -z "${task_url}" ]]; then
    echo "Failed to submit task (no task URL found). Output:" >&2
    echo "${out}" >&2
    exit 2
  fi
  task_id="${task_url##*/}"
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
      exit 2
    fi
    sleep "${poll_secs}"
  done

  # Apply changes from the cloud task.
  if ! codex cloud apply "${task_id}"; then
    echo "Failed to apply cloud diff for task ${task_id}." >&2
    exit 2
  fi

  # Guardrails: only allow `work/` changes, and enforce exactly one new checkpoint file.
  changed="$(git status --porcelain)"
  if [[ -z "${changed}" ]]; then
    echo "No local changes after apply; stopping."
    exit 0
  fi

  disallowed="$(git diff --name-only | grep -Ev '^(work/)' || true)"
  if [[ -n "${disallowed}" ]]; then
    echo "Refusing to commit: changes outside work/ detected:" >&2
    printf '%s\n' "${disallowed}" >&2
    exit 2
  fi

  new_checkpoint_files="$(git diff --name-only --diff-filter=A | grep -E '^work/checkpoints/[0-9]{8}-[0-9]{4}\\.md$' || true)"
  checkpoint_count="$(printf '%s\n' "${new_checkpoint_files}" | sed '/^$/d' | wc -l | tr -d ' ')"
  if [[ "${checkpoint_count}" != "1" ]]; then
    echo "Refusing to commit: expected exactly 1 new checkpoint file, found ${checkpoint_count}." >&2
    printf '%s\n' "${new_checkpoint_files}" >&2
    exit 2
  fi

  checkpoint_file="$(printf '%s\n' "${new_checkpoint_files}" | head -n 1)"
  checkpoint_stamp="${checkpoint_file##*/}"
  checkpoint_stamp="${checkpoint_stamp%.md}"

  if ! git diff --name-only | grep -q '^work/STATE.md$'; then
    echo "Refusing to commit: expected work/STATE.md to be modified." >&2
    exit 2
  fi

  git add work/
  git commit -m "checkpoint: ${checkpoint_stamp} (${task_id})"
  git push origin "${branch}"
done
