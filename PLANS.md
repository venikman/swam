# ExecPlan: Memetics Research Sprint (FPF + Pareto Portfolio)

## Goal
Produce an auditable, citation-heavy research proposal package on **memetics** as a candidate framework for cultural evolution, using FPF patterns and a **Pareto/portfolio** selection policy (no silent scalarization).

## Success criteria (observable)
- All required deliverables exist (see `work/00_deliverables_manifest.md`) and are internally consistent.
- Every nontrivial factual claim is cited to a primary / peer-reviewed / canonical source, with **source date + access date** recorded in `work/reading_list.md`.
- Portfolios are returned where trade-offs remain (explicit Pareto frontier; no “one winner”).
- Uncertainty is explicit: contested claims are labeled, and inferences are marked as inference.
- A durable audit trail exists:
  - checkpoint files in `work/checkpoints/`
  - decisions appended to `work/adr/000_master_decision_log.md`

## Non-goals
- Writing “how to manipulate” or targeted persuasion playbooks (explicitly excluded by spec).
- Platform-specific abuse guidance.
- Exhaustive literature review of all cultural evolution work (timeboxed sprint).

## Constraints (sandbox, network, OS, time, dependencies)
- Environment: macOS, `zsh`, repo root `/Users/stas-studio/Developer/swam`.
- Network: allowed but budgeted (soft cap ≤80 opened web sources). Prefer PDFs/books/encyclopedias over blogs.
- Dependencies: avoid installs unless required. Use existing tools (e.g., `pandoc`) for DOCX extraction.
- Safety: no actionable guidance for coercive persuasion.
- Citation discipline: no unreferenced factual claims; include source date + access date in the bibliography.
- Comparison discipline (FPF): no hidden scalarization; do not average ordinals as intervals; return set-valued outcomes when partial order remains.

## Repo map (key files/dirs)
- Inputs/spec:
  - `spec/Memetics_Research_Bundle_FPF.docx` (task spec; extracted to `tmp/docs/`)
  - `spec/FPF-Spec.md` (method library; constraints/patterns)
- Context:
  - `context/project_brief.md`
  - `context/levencuk_context_notes.md`
- Deliverables:
  - `work/` (see `work/00_deliverables_manifest.md`)
  - `work/adr/000_master_decision_log.md`
  - `work/checkpoints/`
- Templates:
  - `templates/acceptance_spec_template.md`
  - `templates/parity_plan_template.md`
  - `templates/adr_template.md`

## Milestones
1. **Bootstrap + governance**
   - Steps
     - Extract DOCX spec to text/MD (no formatting guarantees) under `tmp/docs/`.
     - Create `work/adr/000_master_decision_log.md` with initial ADRs (citation scheme; scope boundaries; framing set).
     - Create `work/acceptance_spec.md` (problem + acceptance + selection policy).
   - Validation
     - `test -f tmp/docs/Memetics_Research_Bundle_FPF.md`
     - `test -f work/acceptance_spec.md`
     - `test -f work/adr/000_master_decision_log.md`
   - Rollback
     - `git revert <commit>` (if committed) or discard new files.

2. **Evidence pack + source registry**
   - Steps
     - Build `work/reading_list.md` as the source registry (IDs `S01`, `S02`, …).
     - Build `work/evidence_pack.md` with extracted definitions/claims/quotes, each linked to source IDs.
   - Validation
     - `test -f work/reading_list.md && rg -n \"^S[0-9]{2}:\" work/reading_list.md | wc -l`
     - `test -f work/evidence_pack.md && rg -n \"\\[S[0-9]{2}\\]\" work/evidence_pack.md | head`
   - Rollback
     - Revert the commit for this milestone.

3. **Concept map + characterization passport**
   - Steps
     - Create `work/memetics_map.md` (schools/claims/falsifiers/links to evidence).
     - Define “quality” / measurement indicators and comparability rules (passport section embedded in map and reused by parity plan).
   - Validation
     - `test -f work/memetics_map.md`
     - `rg -n \"Indicators|Measurement|Comparability\" work/memetics_map.md`
   - Rollback
     - Revert the commit for this milestone.

4. **Hypothesis + problem portfolios (Pareto)**
   - Steps
     - Generate ≥12 candidate hypotheses/problems in `work/hypothesis_portfolio.md` and `work/problem_portfolio.md`.
     - Prune to an explicit Pareto frontier set (~5–7) using declared characteristics (no scalar collapse).
     - Record any dropped alternatives in ADR log (dominated-by notes + criteria).
   - Validation
     - `test -f work/hypothesis_portfolio.md && rg -n \"Pareto\" work/hypothesis_portfolio.md`
     - `test -f work/problem_portfolio.md && rg -n \"Pareto\" work/problem_portfolio.md`
   - Rollback
     - Revert the commit for this milestone.

5. **Parity compare the three framings**
   - Steps
     - Author `work/parity_plan.md` (pinned windows, indicators, protocol).
     - Produce `work/parity_report.md` (results as sets; contested points labeled; citations).
   - Validation
     - `test -f work/parity_plan.md && test -f work/parity_report.md`
     - `rg -n \"Candidates\" work/parity_plan.md && rg -n \"Results\" work/parity_report.md`
   - Rollback
     - Revert the commit for this milestone.

6. **Study designs + final proposal surface**
   - Steps
     - Produce `work/study_designs.md` (per-frontier item: dataset, variables, analysis, confounders, ethics).
     - Ensure `work/reading_list.md` covers all cited sources and includes source date + access date.
   - Validation
     - `test -f work/study_designs.md`
     - `rg -n \"Accessed:\" work/reading_list.md`
     - `rg -n \"\\[S[0-9]{2}\\]\" work/*.md | wc -l`
   - Rollback
     - Revert the commit for this milestone.

## Decisions log (why changes)
- Decision details live in `work/adr/000_master_decision_log.md` (append-only).

## Progress log (ISO-8601 timestamps)
- 2026-02-05T18:05:00-05:00
  - Done: Extracted `spec/Memetics_Research_Bundle_FPF.docx` to `tmp/docs/` via `pandoc`.
  - Next: Milestone 1 bootstrap files (`work/acceptance_spec.md`, ADR log), then start evidence registry.
  - Blockers: None.

- 2026-02-05T18:11:00-05:00
  - Done: Milestone 1 bootstrap completed (ExecPlan, acceptance spec, ADR log, initial source registry, first checkpoint). Commit: `e517b5e`.
  - Next: Expand `work/reading_list.md` with primary/peer-reviewed/canonical sources and start `work/evidence_pack.md`.
  - Blockers: None.

- 2026-02-05T18:37:00-05:00
  - Done: Drafted Milestone 2 artifacts (expanded `work/reading_list.md` + wrote `work/evidence_pack.md` + created checkpoint `work/checkpoints/20260205-1834.md`).
  - Next: Milestone 3 concept map + characterization passport (`work/memetics_map.md`), then parity plan (`work/parity_plan.md`).
  - Blockers: None.

- 2026-02-05T18:38:00-05:00
  - Done: Milestone 2 committed (evidence pack + expanded source registry). Commit: `8e46667`.
  - Next: Write `work/memetics_map.md`, then parity compare artifacts.
  - Blockers: None.

- 2026-02-05T18:50:00-05:00
  - Done: Milestones 3+5 committed (concept map + characterization passport; parity plan + parity report). Commit: `96ead91`.
  - Next: Generate and prune hypothesis/problem portfolios, record pruning ADR, then write study designs.
  - Blockers: None.

- 2026-02-05T18:52:00-05:00
  - Done: Milestones 4+6 committed (hypothesis/problem portfolios + study designs + ADR updates). Commit: `324193e`.
  - Next: Run validation commands; ensure all manifest deliverables exist and are citation-covered; fix any gaps.
  - Blockers: None.

---

# ExecPlan: Codex Workflow Hardening (Skills + Automations + Rules + Cloud Setup)

## Goal
Make this repo’s Codex workflow more durable and low-friction by:
- encoding the “checkpoint + STATE update” loop as a repo skill,
- tightening the automation prompt so it cannot forget checkpoint contents,
- adding a safe command allowlist (Rules) to reduce permission stalls,
- adding a cloud-environment setup script + documenting how to wire it,
- updating README guidance to match current published Codex plan limits/models.

## Success criteria (observable)
- A repo skill exists at `.agents/skills/checkpoint/SKILL.md`.
- `prompts/02_codex_automation_prompt.txt` invokes `$checkpoint` and no longer omits checkpoint content requirements.
- A Rules file exists under `.codex/rules/` with conservative `prefix_rule(...)` allowlisting for routine commands.
- A cloud setup script exists at `scripts/codex_setup.sh` and is syntactically valid (`bash -n`).
- `README.md` reflects current published plan limits/models (with explicit “accessed” date and link targets).
- `git status --porcelain` is clean after changes.

## Non-goals
- Changing Codex app settings for the user (only repo artifacts + documentation).
- Upgrading project dependencies or introducing new runtime requirements.
- Changing the memetics deliverables under `work/` (this is scaffold hardening only).

## Constraints (sandbox, network, OS, time, dependencies)
- Environment: macOS, `zsh`, repo root `/Users/stas-studio/Developer/swam`.
- Network: allowed only to verify official OpenAI Codex docs (domain allowlist: `developers.openai.com`, `openai.com`).
- Safety: Rules allowlist must stay conservative (no broad prefixes like `git `, no destructive commands).

## Repo map (key files/dirs)
- Skills: `.agents/skills/`
- Rules: `.codex/rules/`
- Prompts: `prompts/02_codex_automation_prompt.txt`
- Docs: `README.md`, `AGENTS.md`
- Scripts: `scripts/codex_setup.sh`

## Milestones
1. **Checkpoint skill + automation prompt fix**
   - Steps
     - Create `.agents/skills/checkpoint/SKILL.md`.
     - Update `prompts/02_codex_automation_prompt.txt` to call `$checkpoint`.
   - Validation: `test -f .agents/skills/checkpoint/SKILL.md && rg -n '\\$checkpoint' prompts/02_codex_automation_prompt.txt`
   - Rollback: `git revert <commit>`

2. **Rules allowlist (conservative)**
   - Steps
     - Add `.codex/rules/*.rules` with minimal `prefix_rule(...)` entries.
   - Validation: `test -f .codex/rules/*.rules && rg -n \"^\\s*prefix_rule\\(\" .codex/rules/*.rules`
   - Rollback: `git revert <commit>`

3. **Cloud setup script**
   - Steps
     - Add `scripts/codex_setup.sh` (idempotent, non-interactive).
   - Validation: `test -f scripts/codex_setup.sh && bash -n scripts/codex_setup.sh`
   - Rollback: `git revert <commit>`

4. **Docs alignment**
   - Steps
     - Update `README.md` to reflect current plan limits/models and describe the new skill/rules/setup script.
     - (Optional) Align `prompts/00_codex_thread_prompt.md` model naming with README.
   - Validation: `rg -n \"gpt-5\\.3-codex|gpt-5\\.1-codex-mini|18 ?000|5h\" README.md prompts/00_codex_thread_prompt.md`
   - Rollback: `git revert <commit>`

5. **One-shot Cloud trigger (push master, trigger once)**
   - Steps
     - Add `scripts/codex_cloud_trigger.sh` wrapper for `codex cloud exec`.
     - Add `.codex/local.env.example` + ignore `.codex/local.env`.
     - Update `README.md` with the one-command CLI trigger flow.
   - Validation:
     - `bash -n scripts/codex_cloud_trigger.sh`
     - `test -f .codex/local.env.example`
     - `rg -n \"codex cloud exec\" scripts/codex_cloud_trigger.sh`
   - Rollback
     - `git revert <commit>`

## Decisions log (why changes)
- Keep changes small and reversible; one milestone per commit.
- Prefer repo-scoped skills/rules to reduce prompt bloat and permission stalls.
- Keep Rules conservative to avoid allowing destructive commands.

## Progress log (ISO-8601 timestamps)
- 2026-02-05T21:06:50-05:00
  - Done: Planned workflow hardening changes (this ExecPlan).
  - Next: Milestone 1 (checkpoint skill + automation prompt fix).
  - Blockers: None.

- 2026-02-05T21:10:09-05:00
  - Done: Milestone 1 complete (repo checkpoint skill + automation prompt uses `$checkpoint`). Commit: `b810274`.
  - Done: Milestone 2 complete (conservative Codex Rules allowlist). Commit: `1a140fb`.
  - Next: Milestone 3 (cloud setup script) then Milestone 4 (docs alignment).
  - Blockers: None.

- 2026-02-05T21:15:55-05:00
  - Done: Milestone 3 complete (Codex cloud setup script). Commit: `38ea5ad`.
  - Done: Milestone 4 complete (docs alignment: README + thread prompt). Commit: `b6ab49d`.
  - Next: Run final repo validations and keep the hardening changes conservative over time (avoid broad Rules prefixes).
  - Blockers: None.

- 2026-02-05T22:50:43-05:00
  - Done: Added Milestone 5 (one-shot Cloud trigger) + implemented it (trigger script, local env template, README update, gitignore).
  - Next: Update PR branch and merge when ready.
  - Blockers: None.
