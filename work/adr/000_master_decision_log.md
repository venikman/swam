# Master Decision Log (ADR)

This file is **append-only**. Each entry records: decision, alternatives, evidence, consequences, and rollback/refresh triggers. The goal is auditability and restartability. [S02] [S04]

---

## ADR-000: Source Registry + Citation Key Scheme (`S##`)

- Status: accepted
- Date: 2026-02-05
- Valid-until: 2026-08-05 (refresh if the repo adopts a different citation toolchain, e.g., Zotero/BibTeX)
- Decision owner: Principal
- Scope: `/work/*` deliverables

### Context
The deliverables require that every nontrivial factual claim is cited with dates, and that the work remains auditable/resumable. [S01] [S03]

### Forces
- Citations must be easy to apply consistently across many files.
- Citations must be grep-able for quick audits.
- We need to record both **source date** and **access date** without repeating full bibliographic strings everywhere.

### Decision
Maintain `work/reading_list.md` as a **source registry** with stable IDs `S##` and cite sources inline as `[S##]` with optional locators (e.g., `[S12: sec.3]`). Each source entry records: full citation, evidence level, source date, access date, and a stable link (URL/DOI or repo path). [S01]

### Alternatives considered
- A: Markdown footnotes per file (harder to reuse across files; harder to audit globally).
- B: BibTeX + pandoc citeproc (strong, but adds toolchain complexity; not required by current repo).
- C: Ad-hoc URLs inline (auditable but noisy; encourages inconsistent bibliographic formats).

### Evidence
- Citation + audit requirements and bibliography fields appear in the task spec. [S01]
- FPF emphasizes explicit evidence anchoring and comparability governance; set-valued outputs under partial orders. [S02]

### Consequences
- Positive: Consistent citations; easy cross-file auditing; reading list becomes single source of truth.
- Negative: Requires discipline to ensure every claim has at least one `[S##]` marker; locators are manual.
- Follow-ups: Add a lightweight “citation coverage” check during validation (grep for uncited claim markers where feasible).

### Rollback plan
If the project adopts BibTeX/Zotero, migrate by mapping `S##` to `@keys` and updating citations; keep `work/reading_list.md` as a compatibility index until all files are migrated.

---

## ADR-001: Scope and Safety Boundary (No Manipulation Playbooks)

- Status: accepted
- Date: 2026-02-05
- Valid-until: 2026-08-05 (refresh if project objective changes)
- Decision owner: Principal
- Scope: content of all deliverables under `/work/`

### Context
The project aims to produce an auditable research proposal on memetics and competing framings, while explicitly excluding “instructions for manipulation” and platform-specific abuse guidance. [S01] [S03]

### Forces
- Memetics can be (mis)used for persuasion/manipulation narratives; the spec prohibits that.
- Still need to discuss diffusion mechanisms at a scientific/measurement level.

### Decision
Exclude:
- normative/political messaging tactics,
- targeted persuasion/coercion instructions,
- platform-specific abuse playbooks.

Include only:
- descriptive models, operational definitions, measurement options, critiques, and ethically-scoped study designs. [S01] [S03]

### Alternatives considered
- A: Full applied “growth/messaging” playbooks (rejected: violates spec safety constraints). [S01]
- B: Purely philosophical discussion with no empirical hooks (rejected: violates “testable/tractable” acceptance criteria). [S01]

### Evidence
- Explicit inclusion/exclusion list in the task spec. [S01]
- Repo project brief constraints and stop conditions. [S03]

### Consequences
- Positive: Keeps the work aligned with safety constraints and reviewability.
- Negative: Some applied memetics literature (marketing/persuasion) will be cited only insofar as it is descriptive and non-actionable.
- Follow-ups: For each study design, include an ethics/safety note and avoid intervention recommendations beyond measurement.

### Rollback plan
If scope expands later, create a new ADR describing the expanded boundary and add explicit deontic constraints (what remains forbidden).

---

## ADR-002: Required Framing Set for Parity Comparison

- Status: accepted
- Date: 2026-02-05
- Valid-until: 2026-08-05 (refresh if new dominant framing emerges or project focus changes)
- Decision owner: Principal
- Scope: `work/parity_plan.md`, `work/parity_report.md`, and framing sections in other deliverables

### Context
To avoid a “single school” bias, the work plan requires parity comparison across three framings:
1) memetics-as-replicators,
2) dual-inheritance / cultural evolution (population thinking),
3) epidemiology of representations. [S01]

### Forces
- The term “memetics” is controversial; credible alternatives exist with stronger empirical toolkits.
- The deliverables must produce a Pareto set rather than a single winner when trade-offs remain.

### Decision
Treat the above three as first-class candidates in parity evaluation and concept mapping; do not collapse to a single “best” framing. Results must be published as a set/portfolio when a partial order remains. [S01] [S02]

### Alternatives considered
- A: Focus only on memetics-as-replicators (rejected: likely dominated on empirical tractability; also ignores major critiques). [S01]
- B: Treat all cultural evolution as “memetics” (rejected: blurs distinctions; risks equivocation without explicit bridging). [S02]

### Evidence
- Framing requirement and Pareto/portfolio rule in the task spec. [S01]
- FPF constraints: set-valued outcomes under partial orders; no hidden scalarization. [S02]

### Consequences
- Positive: Makes trade-offs visible; supports an auditable decision frontier.
- Negative: Requires more upfront work (more sources and careful definition discipline).
- Follow-ups: Add a “bridge notes” section capturing where terms appear similar but differ across framings.

### Rollback plan
If one framing becomes clearly dominated for the project’s acceptance criteria, record the dominance argument (with evidence) and deprecate it via a superseding ADR.

---

## ADR-003: Treat “Meme” as a Portfolio of Candidate Constructs (No Forced Single Definition)

- Status: accepted
- Date: 2026-02-05
- Valid-until: 2026-08-05 (refresh if a new synthesis provides a dominant operational definition with clear measurement superiority in the target domain)
- Decision owner: Principal
- Scope: `work/memetics_map.md`, `work/hypothesis_portfolio.md`, `work/problem_portfolio.md`, `work/parity_*`

### Context
Across the literature, “meme” is used in both strong (replicator-like) and weak (unit-of-imitation / cultural item) senses, and also as a pragmatic proxy label in online diffusion studies. Treating these as the same object risks equivocation and untestable debates. [S28] [S05] [S24]

### Forces
- We must avoid “silent scalarization” and preserve alternatives when trade-offs exist. [S01] [S02]
- We must keep definitions operational and falsifiable (or explicitly mark as contested/unknown). [S01] [S28]
- We need to support parity comparison across three framings without straw-manning any single one. [S01] [S02]

### Decision
Represent “meme” as a **set of candidate constructs** (portfolio), at minimum:
- strong replicator-claim meme (empirical claim; falsifiable),
- weak unit-of-imitation gloss (often underconstrained),
- operational proxy (e.g., hashtags-as-memes in a bounded data channel). [S28] [S24] [S06]

Do not collapse these into a single “true” definition in v0.1. [S01] [S02]

### Alternatives considered
- A: Pick one “official” definition of meme (rejected: high risk of equivocation or premature commitment; contested). [S28]
- B: Declare memetics “invalid” and drop it (rejected: violates required parity set; also removes a useful hypothesis class). [S01] [S02]
- C: Treat “meme” as purely metaphorical and non-operational (rejected: fails the “testable/tractable” acceptance criteria). [S01]

### Evidence
- Strong vs weak “meme” distinction and “meme as substantive empirical claim” argument. [S28]
- Critique that memetics debates reveal misunderstandings in Darwinian cultural evolution and warn against over-literal gene↔culture analogy. [S05]
- Online operationalization: hashtags used as meme proxies within a limited-attention diffusion model. [S24]

### Consequences
- Positive: Keeps debates legible; enables explicit falsifiers; supports Pareto/portfolio outputs.
- Negative: Requires extra work in every study design to state which “meme” construct is in play and how it is measured.
- Follow-ups: In `work/study_designs.md`, each proposed study must declare which construct(s) it tests and why.

### Rollback plan
If a particular construct becomes clearly dominated for the bounded context (e.g., cannot be operationalized; no plausible falsifiers), record dominance in a new ADR and deprecate it for that context.

---

## ADR-004: Characterization Passport Indicator Set (I1–I8) for Parity + Portfolio Selection

- Status: accepted
- Date: 2026-02-05
- Valid-until: 2026-08-05 (refresh if the project scope changes or new measurement tooling/data access materially changes tractability)
- Decision owner: Principal
- Scope: `work/memetics_map.md`, `work/parity_plan.md`, `work/parity_report.md`, and portfolio pruning rules

### Context
We need a shared indicator set to compare framings and to prune hypothesis/problem portfolios to a Pareto frontier without collapsing mixed measurement types into a single score. [S01] [S02]

### Forces
- Must support set-valued/Pareto selection; avoid ordinal averaging. [S01] [S02]
- Must be anchored in what the sources emphasize as core disputes: unit clarity, copying vs transformation, mechanism specificity, and empirical tractability. [S28] [S22] [S14] [S24]
- Must respect safety boundary: no manipulation playbooks. [S01]

### Decision
Adopt the indicator set defined in `work/memetics_map.md` Section 5 (I1–I8), covering:
unit explicitness, proxy availability, transmission mode fit, falsifiability hooks, predictive leverage, mechanism specificity, data/compute tractability, ethical/safety risk. [S02] [S01]

### Alternatives considered
- A: Single composite “score” (rejected: violates no-scalarization constraint). [S01] [S02]
- B: Purely narrative comparison with no indicators (rejected: weak auditability; harder to reproduce parity results). [S02]
- C: Indicator set focused only on online diffusion metrics (rejected: too narrow for memetics-as-framework comparison). [S14] [S18]

### Evidence
- Portfolio/Pareto selection requirement and parity discipline in task spec. [S01]
- FPF constraints on mixed measurement types and set-valued outcomes. [S02]
- Empirical anchors motivating tractability and mechanism indicators: limited attention models and complex contagion reinforcement. [S24] [S26]
- Transformation/attraction critiques motivating the transmission-fit indicator. [S28] [S22] [S29]

### Consequences
- Positive: Enables a consistent Pareto comparison across deliverables; supports reproducible parity plan/report.
- Negative: Indicator levels are initially coarse (mostly ordinal/qual) and may require refinement once a bounded domain/dataset is chosen.
- Follow-ups: In `work/parity_plan.md`, specify per-indicator measurement procedures and handling of “unknown/missing”.

### Rollback plan
If indicator set is found to omit a critical stakeholder constraint (e.g., privacy constraints for a chosen dataset), add a new ADR superseding this indicator set and update parity + portfolios accordingly.

---

## ADR-005: v0.1 Portfolio Pruning Results (Hypotheses + Problems)

- Status: accepted
- Date: 2026-02-05
- Valid-until: 2026-08-05 (refresh if bounded context changes, new datasets/tooling arrive, or dominance relations change under refined indicators)
- Decision owner: Principal
- Scope: `work/hypothesis_portfolio.md`, `work/problem_portfolio.md`, `work/study_designs.md`

### Context
The sprint requires generating ≥12 candidates for hypotheses and research problems, then selecting a **Pareto frontier** (≈5–7) without collapsing mixed measurement types into a single score. [S01] [S02]

### Forces
- Must preserve alternatives when trade-offs remain; publish sets, not a single winner. [S01] [S02]
- Must retain empirical tractability anchored in at least one online diffusion proxy context, while also testing the copying↔transformation dispute central to memetics critiques. [S24] [S28] [S22]
- Must enforce safety boundary (no manipulation playbooks). [S01]

### Decision
Select the following v0.1 frontier items for study design focus:

Hypothesis frontier (from `work/hypothesis_portfolio.md`):
- H03 (Proxy sensitivity) [S24] [S28]
- H07 (Attention improves prediction) [S24]
- H08 (Complex contagion for meme sharing) [S26]
- H04 (Attractor convergence under transmission) [S22] [S29]
- H06 (Strong vs weak meme operationalization) [S28]
- H11 (F1 as special case classifier) [S28] [S14]

Problem frontier (from `work/problem_portfolio.md`):
- P01 (Unit/proxy sensitivity) [S24] [S28]
- P02 (Attention-limited prediction) [S24]
- P03 (Complex contagion thresholds) [S26]
- P04 (Attractor detection in transmission) [S22] [S29]
- P05 (Transmission mode measurement templates) [S28] [S29]
- P06 (Domain classifier for F1 special-case) [S28] [S14]

Non-frontier items remain documented as alternates; they are not deleted. [S01]

### Alternatives considered
- A: Keep all candidates “equally active” (rejected: violates timebox; reduces tractability). [S01]
- B: Collapse to a single top-ranked hypothesis/problem (rejected: violates Pareto-only constraint). [S01] [S02]
- C: Focus only on online diffusion proxies (rejected: fails to test copying↔transformation dispute central to memetics critiques). [S28] [S22]

### Evidence
- Pareto/portfolio requirement + timebox constraints. [S01]
- FPF constraints on mixed measurement types and set-valued outcomes. [S02]
- Online tractability anchors: attention-limited meme competition proxy work. [S24]
- Mechanism anchor: complex contagion reinforcement. [S26]
- Transformation/attraction anchor: cultural attractors + graded culturalness and re-production critique. [S22] [S29] [S28]

### Consequences
- Positive: Concentrates effort on a balanced frontier spanning (a) online proxy tests and (b) transmission/transformation tests.
- Negative: Some microfoundation-deepening alternates (representation mapping; graded culturalness) remain deferred pending better measurement templates and/or bounded domain selection. [S18] [S29]
- Follow-ups: `work/study_designs.md` will define minimal study designs for each frontier problem/hypothesis pair, including falsifiers and confounders. [S01]

### Rollback plan
If new data access or refined measurement templates change tractability, rerun Pareto pruning under updated indicators and record a superseding ADR with the new frontier.
