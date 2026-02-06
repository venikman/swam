#!/usr/bin/env bash
set -euo pipefail

# Codex App automations run in a dedicated worktree. This script makes the
# automation "self-syncing" by committing + pushing slice outputs to origin.
#
# Guardrails:
# - Only changes under work/ are allowed.
# - Requires exactly one new checkpoint file under work/checkpoints/YYYYMMDD-HHMM.md
# - Requires work/STATE.md to be modified.

export GIT_TERMINAL_PROMPT=0

die() {
  echo "codex_automation_sync: ERROR: $*" >&2
  exit 1
}

repo_root="$(git rev-parse --show-toplevel 2>/dev/null)" || die "not inside a git repo"
cd "$repo_root"

git fetch origin --prune >/dev/null 2>&1 || true

if [ -z "$(git status --porcelain=v1)" ]; then
  echo "codex_automation_sync: no changes; nothing to do"
  exit 0
fi

# Gate: refuse to push if the slice is structurally invalid or missing required
# audit sections (search log + gate checks).
if ! bash scripts/codex_slice_gate.sh; then
  die "slice gate failed"
fi

# Collect all changed paths (staged, unstaged, untracked)
tmp_list="$(mktemp)"
trap 'rm -f "$tmp_list"' EXIT

git diff --name-only >"$tmp_list" || true
git diff --cached --name-only >>"$tmp_list" || true
git ls-files --others --exclude-standard >>"$tmp_list" || true

sort -u "$tmp_list" | while IFS= read -r path; do
  [ -n "$path" ] || continue
  case "$path" in
    work/*) ;;
    *)
      die "refusing to sync: changed path outside work/: $path"
      ;;
  esac
done

if ! git status --porcelain=v1 -- "work/STATE.md" | grep -q .; then
  die "work/STATE.md not modified (slice must update STATE + write exactly one checkpoint)"
fi

ckpt_paths="$(
  git status --porcelain=v1 -- "work/checkpoints/*.md" \
    | awk '($1=="??" || substr($1,1,1)=="A"){print $2}' \
    | grep -E '^work/checkpoints/[0-9]{8}-[0-9]{4}\.md$' \
    || true
)"
ckpt_count="$(printf "%s\n" "$ckpt_paths" | sed '/^$/d' | wc -l | tr -d ' ')"

if [ "$ckpt_count" -ne 1 ]; then
  die "expected exactly 1 new checkpoint file under work/checkpoints/, found: $ckpt_count"
fi

ckpt_path="$(printf "%s\n" "$ckpt_paths" | sed '/^$/d' | head -n 1)"
ckpt_id="$(basename "$ckpt_path" .md)"

git add -- work

if git diff --cached --quiet; then
  echo "codex_automation_sync: nothing staged; nothing to commit"
  exit 0
fi

git -c user.name="Codex Automation" \
    -c user.email="codex-automation@users.noreply.github.com" \
    commit -m "work: checkpoint $ckpt_id" >/dev/null

# Rebase the new commit(s) onto the latest origin/master, then fast-forward push.
git fetch origin master --prune >/dev/null 2>&1 || true
if git show-ref --verify --quiet refs/remotes/origin/master; then
  git rebase origin/master >/dev/null
fi

git push origin HEAD:master
echo "codex_automation_sync: pushed checkpoint $ckpt_id to origin/master"
