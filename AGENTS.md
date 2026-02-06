# Repo instructions for Codex (keep this file small)

Goal: maximize long-horizon progress per *included* ChatGPT Pro Codex limits.

Always:
- Treat `work/STATE.md` as canonical external memory; update it whenever you write a checkpoint.
- Keep context small: do not paste large excerpts; write summaries into repo files instead.
- Prefer small, reviewable diffs; avoid repo-wide rewrites unless necessary.
- If you hit any platform limit, permission prompt, or usage warning: write a checkpoint + update `work/STATE.md`, then stop cleanly.

Optional (when using multiple agents):
- Use separate worktrees/branches per agent.
- Each agent should produce one focused diff + one checkpoint, then hand off to the lead agent for merge/integration.

Full workflow: `prompts/00_codex_thread_prompt.md`
