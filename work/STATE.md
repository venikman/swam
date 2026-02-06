# STATE (canonical memory; keep short)

## Objective
- Produce the memetics research package under `work/` (see `work/00_deliverables_manifest.md`) using resumable slices (STATE + checkpoints).

## Hard constraints
- Citations for nontrivial factual claims.
- No manipulation playbooks.
- Portfolio/Pareto policy when criteria conflict.

## Current status
- Last checkpoint: 20260205-1851
- Deliverables status: All manifest deliverables present.

## Next actions (3–7)
1. (Workflow) If using GitHub Actions autopilot: add repo secret `OPENAI_API_KEY` and (optional) commit `work/AUTOPILOT.enabled` to enable scheduled runs.
2. (Workflow) Validate the repo in a fresh clone/container and decide whether `tmp/docs/Memetics_Research_Bundle_FPF.md` should be regenerated in setup (vs treated as local-only).
3. (Research) If continuing: pick one frontier item from `work/problem_portfolio.md` and add 2–5 high-quality sources + extracted evidence.

## Open questions / unknowns
- Should Codex autopilot run via Codex Cloud (ChatGPT-included, local orchestrator) or GitHub Actions (API-key billed)?
- Should spec extraction under `tmp/docs/` be treated as a volatile build artifact (regen) or tracked?

## Notes for continuation
- If resuming: read this file, then read the newest file in `work/checkpoints/`, then continue.
- Keep this file compact to reduce context/usage.
