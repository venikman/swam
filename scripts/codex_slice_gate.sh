#!/usr/bin/env bash
set -euo pipefail

# Lightweight "tests/lint + quality" gate for automation slices.
# This is intentionally conservative: it hard-fails only on structural invariants
# that keep the automation self-syncing and reviewable.

say() {
  echo "codex_slice_gate: $*"
}

warn() {
  say "WARN: $*"
}

fail() {
  say "FAIL: $*"
  exit 1
}

repo_root="$(git rev-parse --show-toplevel 2>/dev/null)" || fail "not inside a git repo"
cd "$repo_root"

if [ -z "$(git status --porcelain=v1)" ]; then
  say "PASS (no changes)"
  exit 0
fi

# Collect all changed paths (staged, unstaged, untracked) and ensure they are scoped to work/.
tmp_list="$(mktemp)"
trap 'rm -f "$tmp_list"' EXIT

git diff --name-only >"$tmp_list" || true
git diff --cached --name-only >>"$tmp_list" || true
git ls-files --others --exclude-standard >>"$tmp_list" || true

changed_paths="$(sort -u "$tmp_list" | sed '/^$/d')"
while IFS= read -r path; do
  [ -n "$path" ] || continue
  case "$path" in
    work/*) ;;
    *)
      fail "changed path outside work/: $path"
      ;;
  esac
done <<<"$changed_paths"

if ! git status --porcelain=v1 -- "work/STATE.md" | grep -q .; then
  fail "work/STATE.md not modified"
fi

# Exactly one *new* checkpoint file must exist (untracked at gate time).
ckpt_paths="$(git ls-files --others --exclude-standard -- "work/checkpoints/*.md" | grep -E '^work/checkpoints/[0-9]{8}-[0-9]{4}\.md$' || true)"
ckpt_count="$(printf '%s\n' "$ckpt_paths" | sed '/^$/d' | wc -l | tr -d ' ')"
if [ "$ckpt_count" -ne 1 ]; then
  fail "expected exactly 1 new checkpoint file under work/checkpoints/, found: $ckpt_count"
fi

ckpt_path="$(printf '%s\n' "$ckpt_paths" | sed '/^$/d' | head -n 1)"
ckpt_id="$(basename "$ckpt_path" .md)"

# STATE should point at the same checkpoint id (prevents "dangling" checkpoints).
if ! rg -n "Last checkpoint:\\s+${ckpt_id}\\b" -- "work/STATE.md" >/dev/null; then
  fail "work/STATE.md Last checkpoint does not match $ckpt_id"
fi

# Required checkpoint sections (so "search-first" and "gate checks" are auditable).
if ! rg -n "^##\\s+Search\\s*/\\s*exploration\\s+log\\s*$" -- "$ckpt_path" >/dev/null; then
  fail "checkpoint missing required heading: '## Search / exploration log'"
fi
if ! rg -n "^##\\s+Gate\\s+checks\\s*$" -- "$ckpt_path" >/dev/null; then
  fail "checkpoint missing required heading: '## Gate checks'"
fi

# If new sources were added to reading_list, ensure they are referenced in evidence_pack and the checkpoint.
new_source_ids="$(
  git diff --unified=0 -- "work/reading_list.md" \
    | rg '^\\+###\\s+S[0-9]{2,3}:' \
    | sed -E 's/^\\+###\\s+(S[0-9]{2,3}):.*$/\\1/' \
    | sort -u \
    || true
)"

if [ -n "$new_source_ids" ]; then
  while IFS= read -r sid; do
    [ -n "$sid" ] || continue
    if ! rg -n "\\b${sid}\\b" -- "work/evidence_pack.md" >/dev/null; then
      fail "new source ${sid} missing from work/evidence_pack.md"
    fi
    if ! rg -n "\\b${sid}\\b" -- "$ckpt_path" >/dev/null; then
      fail "new source ${sid} missing from checkpoint"
    fi
  done <<<"$new_source_ids"
fi

# Non-fatal "thin slice" warnings.
deliverable_changes="$(
  printf '%s\n' "$changed_paths" \
    | rg '^work/' \
    | rg -v '^work/STATE\\.md$' \
    | rg -v '^work/checkpoints/' \
    || true
)"
if [ -z "$deliverable_changes" ]; then
  warn "no deliverable changes detected besides work/STATE.md + checkpoint"
fi

say "PASS"
