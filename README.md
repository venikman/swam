# Memetics research — Codex starter bundle

This repo is a **stateful workspace** for a long-horizon memetics research sprint (outputs as files, resumable after interruptions).

## What’s inside
- `/spec/` — authoritative specs (your memetics bundle + FPF spec)
- `/context/` — project context + extracted notes from the 2026-02-01 talk deck
- `/work/` — where the agent writes deliverables + checkpoints
- `/prompts/` — copy/paste prompts for Codex App / CLI + a resume prompt
- `/templates/` — ADR + parity + acceptance templates (lightweight)

## Quick start (recommended)
1) `git init` (or use a new branch/worktree in an existing repo).
2) Open **Codex app** and select this folder as the project.
3) Paste `prompts/00_codex_thread_prompt.md` into the thread.
4) Let it run. Review diffs; commit checkpoints.

## Long-running mode (multi-hour)
Tip: prefer resumable slices + external memory (`work/STATE.md`) over one giant context window.

Use **Codex app Automations** to “re-trigger” progress periodically:
- Create an Automation scheduled every 15 min (or 30 min).
- Use `prompts/02_codex_automation_prompt.txt` as the automation prompt.
- Each run should end by invoking `$checkpoint` (writes `work/STATE.md` + exactly one new `work/checkpoints/YYYYMMDD-HHMM.md`).

Repo-scoped Codex assets:
- Skill: `.agents/skills/checkpoint/SKILL.md`
- Rules allowlist: `.codex/rules/safe-default.rules`
- Cloud setup script: `scripts/codex_setup.sh`

## Included usage limits (ChatGPT plans)
Codex included usage is measured in rolling **5-hour (18,000 s) windows** and varies with task size/context.
Per the Codex pricing page (accessed **2026-02-06**):

| Plan | Local messages / 5h | Cloud tasks / 5h | Code reviews / week |
| --- | --- | --- | --- |
| ChatGPT Plus | 45–225 | 10–60 | 10–25 |
| ChatGPT Pro | 300–1500 | 50–400 | 100–250 |

To stretch included usage:
- keep prompts/context small (write state to files),
- prefer `gpt-5.1-codex-mini` for routine work (up to ~4x higher local-message limits), reserve `gpt-5.3-codex` for hard steps,
- disable MCP servers you don’t need (they add context and burn budget).

Rationale: automation runs create durable progress via repo artifacts, so you can stop/restart without losing state.

References:
- Codex pricing: https://developers.openai.com/codex/pricing/ (accessed 2026-02-06)
- Codex models: https://developers.openai.com/codex/models/ (accessed 2026-02-06)

## Cloud environments (optional)
If you use Codex Cloud tasks, set the environment setup script to `scripts/codex_setup.sh`.
It installs `pandoc`/`ripgrep`/`git` if missing (Debian/Ubuntu `apt-get`).

## If you prefer the CLI
- `cd` into this folder
- run `codex` and paste `prompts/00_codex_thread_prompt.md`

## What you should edit first
- `context/project_brief.md` — confirm scope, outputs, and “stop conditions”.

## Output contract (where to look)
- Checkpoints: `/work/checkpoints/`
- Core deliverables: `/work/` (see file list in the main prompt)

## Safety / hygiene
- Keep secrets out of this repo.
- Use git checkpoints before/after risky steps.
- If the agent proposes destructive actions, require explicit human confirmation.
- If you enable agent internet access, start with a domain allowlist and treat retrieved content as untrusted input (prompt injection is real).
