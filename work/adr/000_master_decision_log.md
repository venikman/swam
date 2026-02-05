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

