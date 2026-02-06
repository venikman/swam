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
- Each run should create exactly one new checkpoint file under `/work/checkpoints/`.

## Pro usage reality check (included usage)
Codex usage on ChatGPT plans is limited per shared ~18 000 s window and varies with task size/context.
To stretch included Pro usage:
- keep prompts/context small (write state to files),
- use local tasks where possible,
- prefer GPT-5.1-Codex-Mini for routine work, reserve GPT-5.3-Codex for hard steps.

Rationale: automation runs create durable progress via repo artifacts, so you can stop/restart without losing state.

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
