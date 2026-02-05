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
