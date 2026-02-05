# Acceptance Spec (Memetics Research Sprint)

This acceptance spec defines what “done” means for the memetics research sprint, and how we select a **portfolio / Pareto set** rather than a single “winner” when trade-offs remain. [S01] [S02] [S03]

## Problem statement
It is currently not possible (within this repo) to treat “memetics” as a defensible research framework without (a) explicit competing definitions, (b) a map of major critiques and falsifiers, and (c) a small set of tractable, testable research questions with study designs. [S01] [S03]

## Acceptance criteria (hard constraints)
1. **Deliverables present:** all files listed in `work/00_deliverables_manifest.md` exist and are coherent with each other. [S03]
2. **Citation coverage:** every nontrivial factual claim in `/work/` is accompanied by at least one source citation `[S##]`, and every cited `S##` exists in `work/reading_list.md`. [S01] [S03]
3. **Source dates + access dates:** every `S##` entry records source date and access date. [S01]
4. **Evidence quality floor:** include at least **25 high-quality sources** (primary / peer-reviewed / canonical; tertiary sources only for orientation). [S01] [S03]
5. **Uncertainty explicit:** contested claims are labeled as contested; inferences are labeled as inference (not silently upgraded to fact). [S01] [S03]
6. **No manipulation playbooks:** exclude actionable guidance for targeted persuasion/coercion and platform-specific abuse instructions. [S01]
7. **No silent scalarization:** where criteria conflict, return a **set-valued** portfolio / Pareto frontier; do not collapse mixed measurement types into a single score; do not average ordinals as if interval. [S01] [S02]
8. **Audit trail:** decisions are recorded in `work/adr/000_master_decision_log.md` and the work is checkpointed under `work/checkpoints/`. [S01] [S04]

## Optimization goals (soft objectives)
These are the indicators we intentionally improve this cycle, subject to the hard constraints above:
- **Conceptual clarity:** operational definitions with explicit falsifiers and scope boundaries. [S01]
- **Empirical tractability:** preference for questions with realistic datasets and clear measurement templates. [S01]
- **Auditability/resumability:** stable source registry + parity artifacts + checkpoints. [S02] [S04]

## Non-goals
- Normative political strategy or “how to persuade/manipulate” tactics. [S01]
- Exhaustive survey of all cultural evolution literature. [S01]
- Producing a single “best” framing or a single ranked list where trade-offs remain. [S01] [S02]

## Measurement plan
- Data sources:
  - `work/*` deliverables (primary artifacts for this sprint). [S03]
  - `work/reading_list.md` as the source registry. (See ADR-000.)
- Procedures:
  - Completeness check: verify all manifest files exist. [S03]
  - Citation check (mechanical): ensure `[S##]` citations appear throughout deliverables; ensure each cited `S##` exists in the register. [S01]
  - Source count and quality check: count distinct `S##` entries; flag tertiary sources and ensure ≥25 high-quality sources exist. [S01]
  - Uncertainty labeling check: spot-check contentious claims for explicit “contested / inference / unknown” marking. [S01]
- Costs:
  - Time budget: v0.1 is a single-day sprint (4–8 hours). [S01]
- Valid-until / refresh triggers:
  - Valid-until: 2026-08-05 (refresh thereafter).
  - Refresh triggers: discovery of a major new synthesis/meta-analysis; new datasets enabling better tests; material changes in online platform data access; major definitional shifts in the scholarly framing. [S01]

## Selection policy (portfolio, not a single winner)
When multiple candidates satisfy acceptance:
- Use a **Pareto-only** selection rule over declared characteristics (e.g., clarity, tractability, expected value, risk/ethics, cost/time), returning a **set** of non-dominated candidates. [S01] [S02]
- If a tie-break is required (still set-valued after Pareto), apply **explicit** tie-break rules (e.g., include “stepping-stone” items that unlock measurement capacity) and record the choice in ADR log. [S01] [S02]
