#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  scripts/codex_cloud_trigger.sh <bootstrap|resume> [--env ENV_ID] [--branch BRANCH] [--attempts N]

Environment:
  CODEX_CLOUD_ENV_ID   Default env id if --env is not provided.

Examples:
  export CODEX_CLOUD_ENV_ID="env_..."
  scripts/codex_cloud_trigger.sh resume
EOF
}

mode="${1:-}"
if [[ -z "${mode}" ]]; then
  usage
  exit 2
fi
shift || true

env_id="${CODEX_CLOUD_ENV_ID:-}"
branch=""
attempts="1"

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
    --attempts)
      [[ $# -ge 2 ]] || { echo "Error: --attempts requires a value" >&2; exit 2; }
      attempts="${2}"
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

if ! [[ "${attempts}" =~ ^[0-9]+$ ]] || (("${attempts}" < 1)); then
  echo "Invalid --attempts value: ${attempts}. Expected a positive integer." >&2
  exit 2
fi

prompt_path=""
case "${mode}" in
  bootstrap)
    prompt_path="prompts/03_codex_cloud_bootstrap_prompt.txt"
    ;;
  resume)
    prompt_path="prompts/04_codex_cloud_resume_prompt.txt"
    ;;
  *)
    echo "Unknown mode: ${mode}. Expected 'bootstrap' or 'resume'." >&2
    usage
    exit 2
    ;;
esac

repo_root="$(git rev-parse --show-toplevel 2>/dev/null || true)"
if [[ -z "${repo_root}" ]]; then
  echo "Not in a git repo (could not find repo root)." >&2
  exit 2
fi
cd "${repo_root}"

if [[ -z "${branch}" ]]; then
  # Prefer the remote default branch (origin/HEAD). Fallback to current local branch.
  origin_head="$(git symbolic-ref -q --short refs/remotes/origin/HEAD 2>/dev/null || true)"
  if [[ -n "${origin_head}" ]]; then
    branch="${origin_head#origin/}"
  else
    branch="$(git rev-parse --abbrev-ref HEAD)"
  fi
fi

if [[ ! -f "${prompt_path}" ]]; then
  echo "Prompt file not found: ${prompt_path}" >&2
  exit 2
fi

# Friendly error if Codex CLI isn't installed/configured.
if ! command -v codex >/dev/null 2>&1; then
  echo "codex CLI not found on PATH. Install it, then retry." >&2
  exit 2
fi

# Guardrail: if the local branch is ahead of origin/<branch>, cloud won't see those commits.
if git rev-parse --verify "origin/${branch}" >/dev/null 2>&1; then
  counts="$(git rev-list --left-right --count "origin/${branch}...${branch}" 2>/dev/null || true)"
  behind=""
  ahead=""
  IFS=$'\t ' read -r behind ahead <<<"${counts}"

  if [[ "${ahead}" =~ ^[0-9]+$ ]] && (("${ahead}" > 0)); then
    echo "Note: local '${branch}' is ahead of 'origin/${branch}' by ${ahead} commit(s)." >&2
    echo "Push first if you want the cloud task to run on your latest changes: git push origin ${branch}" >&2
  fi

  if [[ "${behind}" =~ ^[0-9]+$ ]] && (("${behind}" > 0)); then
    echo "Note: local '${branch}' is behind 'origin/${branch}' by ${behind} commit(s)." >&2
    echo "Pull to sync your local branch with remote: git pull --ff-only" >&2
  fi
fi

query="$(cat "${prompt_path}")"

echo "Submitting Codex Cloud task..."
echo "  env:     ${env_id}"
echo "  branch:  ${branch}"
echo "  prompt:  ${prompt_path}"
echo

codex cloud exec --env "${env_id}" --branch "${branch}" --attempts "${attempts}" "${query}"
