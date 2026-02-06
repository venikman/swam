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
- Create an Automation scheduled hourly (or as frequently as the Automations UI allows).
- Use `prompts/02_codex_automation_prompt.txt` as the automation prompt.
- Each run should end by invoking `$checkpoint` (writes `work/STATE.md` + exactly one new `work/checkpoints/YYYYMMDD-HHMM.md`).

Repo-scoped Codex assets:
- Skill: `.codex/skills/checkpoint/SKILL.md`
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
- prefer `gpt-5.1-codex-mini` for routine work (up to ~4x higher local-message limits), reserve `gpt-5.2-codex` for hard steps,
- disable MCP servers you don’t need (they add context and burn budget).

Rationale: automation runs create durable progress via repo artifacts, so you can stop/restart without losing state.

References:
- Codex pricing: https://developers.openai.com/codex/pricing/ (accessed 2026-02-06)
- Codex models: https://developers.openai.com/codex/models/ (accessed 2026-02-06)
- Codex Quickstart: https://developers.openai.com/codex/quickstart/ (accessed 2026-02-06)
- Codex web overview: https://developers.openai.com/codex/cloud/ (accessed 2026-02-06)
- Cloud environments: https://developers.openai.com/codex/cloud/environments/ (accessed 2026-02-06)
- Agent internet access: https://developers.openai.com/codex/cloud/internet-access/ (accessed 2026-02-06)
- Skills: https://developers.openai.com/codex/skills/ (accessed 2026-02-06)
- Team config: https://developers.openai.com/codex/team-config (accessed 2026-02-06)

## Cloud environments (optional)
Codex Cloud tasks are usually **1–30 min**, so “long-running” work is best done as many short cloud tasks chained together via repo state (`work/STATE.md` + `work/checkpoints/`).

One-time setup:
1) In Codex web, connect GitHub and select `venikman/swam` as the repo.
2) Create/select a Cloud environment for the repo.
3) Set the environment setup script to `scripts/codex_setup.sh` (Debian/Ubuntu `apt-get`; installs `pandoc`/`ripgrep`/`git` if missing).

Notes that matter for autonomy and safety:
- Setup scripts run with internet access; agent internet access is **off by default** and you should keep it off unless you explicitly want live sources (configurable per-environment).
- If you enable agent internet access, use a **domain allowlist** and restrict HTTP methods to `GET`/`HEAD`/`OPTIONS`.
- Codex caches container state for up to **12 hours**. When caching, it clones the repo and checks out the default branch; when resuming a cached container, it checks out the branch specified for the task.

Cloud prompts (copy/paste into Codex web tasks):
- Bootstrap run: `prompts/03_codex_cloud_bootstrap_prompt.txt`
- Resume loop: `prompts/04_codex_cloud_resume_prompt.txt`

CLI trigger (one command after you push the default branch):
1) Set your env id (one-time): `cp .codex/local.env.example .codex/local.env` then edit it.
2) Load it: `source .codex/local.env`
3) Trigger: `scripts/codex_cloud_trigger.sh resume`

Autopilot loop (start once, run many slices):
- Start it: `source .codex/local.env && scripts/codex_cloud_autopilot.sh --max-runs 0`
- It will keep submitting Cloud tasks and pushing results to the remote default branch until:
  - a task fails (e.g., usage limits), or
  - you press Ctrl-C, or
  - you set a finite `--max-runs`.
- Safety: it refuses to commit if the cloud diff touches anything outside `work/`, and it enforces exactly one new `work/checkpoints/*` file per slice.

Quick sanity checks after Run 1:
- A PR exists with edits under `work/`.
- Exactly one new file exists under `work/checkpoints/`.
- `work/STATE.md` was updated with “what changed” + “next actions”.

Parallel cloud tasks without merge hell (pattern):
- Run 2–3 cloud tasks concurrently, each constrained to **one file** (or disjoint file sets) and explicitly **not editing** `work/STATE.md`.
- Each task still creates **exactly one** checkpoint file under `work/checkpoints/` and opens a PR.
- Do NOT invoke `$checkpoint` in parallel tasks (it edits `work/STATE.md`); write the single checkpoint file manually, and let the integrator update `work/STATE.md`.
- Run an “integrator” cloud task to merge PR branches logically and update `work/STATE.md` with the integrated next actions.

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
