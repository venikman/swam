# Parity Plan (Three-Framing Compare)

- Date: 2026-02-05 [S03]
- Valid-until: 2026-08-05 (refresh triggers: new key syntheses, new datasets enabling sharper tests, major definitional shifts, or platform access changes affecting tractability). [S01]
- Comparison discipline: **Pareto-only** outputs; no ordinal averaging as interval; no hidden scalarization. [S01] [S02]

## 1) Context

This repo must compare three framings of “memetics/cultural evolution” on equal footing, and publish results as a **set/portfolio** when trade-offs remain. [S01] [S02]

The objective of this parity run is to support:
- concept clarification and falsifiability mapping (`work/memetics_map.md`), and [S01]
- selection of a research-question and hypothesis **portfolio** (`work/*_portfolio.md`) with explicit study designs. [S01]

## 2) Candidates (fixed set; no substitution)

The candidates are the three required framings (see `work/memetics_map.md`):
1. **F1 Memetics-as-replicators** (strong “meme” as replicator-like unit; contested). [S28] [S05]
2. **F2 Dual-inheritance / cultural evolution** (population-thinking; Darwinian change in socially learned information without requiring gene-like units). [S14] [S05]
3. **F3 Epidemiology of representations / cultural attraction** (culture as distributions of representations; transformative transmission and attractors). [S18] [S22] [S29]

## 3) Budget & windows (pinned)

### 3.1 Time / scope budget
- Time budget: v0.1 parity report is a single-session product (same day). [S01]
- Web sources: soft cap ≤80 opened sources total for the sprint; prefer PDFs/books/encyclopedias over blogs. [S01]

### 3.2 Evidence window
- Evidence corpus: restricted to sources in `work/reading_list.md` as of access date 2026-02-05, plus any explicitly added sources with dates recorded (no “ghost citations”). [S01]
- Known access constraints (WAF/Cloudflare) must be documented and mitigated with stable alternatives when possible (e.g., archive captures; author-hosted PDFs; repository bitstreams). [S01]

### 3.3 Domain window (bounded context)
- Bounded context for v0.1: **framework evaluation** for near-term empirical tractability, with at least one online diffusion anchor (hashtags/retweets; complex contagion). [S24] [S26]
- Explicit non-goals: manipulation tactics; platform abuse playbooks. [S01] [S03]

## 4) Measures (indicators) + admissibility gates

Use the indicator set (I1–I8) adopted in ADR-004 and defined in `work/memetics_map.md`. [S02] [S01]

### 4.1 Admissibility gates (hard)
Any candidate framing can only be included in the parity frontier if:
- **G1 Citation coverage:** all substantive claims in the parity report are cited to `work/reading_list.md` IDs. [S01]
- **G2 Safety:** no manipulation playbooks; only descriptive/measurement-first content. [S01]
- **G3 Falsifiability hooks exist:** at least one falsifier template is stated (even if data is not yet available). [S01] [S02]

### 4.2 Indicator rubric (for report tables)

The rubric is intentionally coarse (ordinal/qual) to avoid fake precision in v0.1; “unknown” is an allowed value and must not be silently converted into a numeric penalty. [S02] [S01]

| ID | Indicator | Type | Polarity | How to measure (v0.1) |
|---|---|---|---|---|
| I1 | Unit explicitness | Ordinal | Higher=better | Does the framing provide an explicit unit/distribution specification and boundary rules for identity/variation? [S28] [S14] |
| I2 | Observable proxy availability | Ordinal | Higher=better | Can we name at least one proxy + extraction procedure for a bounded domain (e.g., hashtags as proxies)? [S24] |
| I3 | Transmission mode fit | Qual/Ordinal | Better fit=better | Is the framing aligned with preservative vs constructive transmission evidence/assumptions for the domain? [S28] [S29] [S22] |
| I4 | Falsifiability hooks | Ordinal | Higher=better | Are there explicit “what would change our mind” tests? [S01] [S02] |
| I5 | Predictive leverage | Ordinal | Higher=better | Can it make forward predictions for at least one measurable outcome? [S24] [S26] |
| I6 | Mechanism specificity | Ordinal | Higher=better | Are causal levers articulated (attention limits, reinforcement, transformation biases)? [S24] [S26] [S22] |
| I7 | Data/compute tractability | Ordinal | Higher=better | Can we run at least one minimal study design with accessible data? [S01] [S24] |
| I8 | Ethical/safety risk | Ordinal | Lower=better | Does the framing tend to invite misuse; can we keep work measurement-first? [S01] |

## 5) Procedure (reproducible parity protocol)

1. **Freeze candidates and indicator set** (Sections 2 and 4; already pinned by ADR-002 and ADR-004). [S01] [S02]
2. **Extract commitments**:
   - For each framing, write a 1-page “commitments + mechanisms + unit/proxy” summary (from `work/memetics_map.md` and `work/evidence_pack.md`). [S01]
3. **Fill the rubric**:
   - Assign each indicator an ordinal/qual level plus a short justification paragraph with citations.
   - Allowed values: `high / medium / low / unknown` (or domain-specific words); do not invent numeric scores. [S02]
4. **Generate falsifiers**:
   - For each framing, state at least one falsifier template and what data could test it. [S01] [S02]
5. **Compute Pareto relation (qualitative partial order)**:
   - Declare dominance only when one framing is **at least as good** on all indicators and **strictly better** on at least one, under the allowed ordinal comparisons.
   - If any indicator is `unknown`, dominance must be marked as **not robust** (report both “possible dominance” and “robust dominance” sets). (Inference; governance requirement to preserve uncertainty.) [S02] [S01]
6. **Publish set-valued result**:
   - Output the non-dominated set (Pareto frontier) and list dominated candidates with explicit dominance arguments and citations. [S01] [S02]

## 6) Outputs (publication surface)

The parity run publishes:
- `work/parity_report.md` containing:
  - candidate summaries,
  - the indicator table,
  - dominance arguments (robust vs possible),
  - a Pareto frontier set (no single winner unless dominance is robust). [S01] [S02]

## 7) Handling unknowns / missing evidence

- Unknowns are first-class outcomes:
  - label `unknown` explicitly,
  - avoid “default penalties”,
  - where needed, produce multiple frontiers under different plausible resolutions. [S02] [S01]

## 8) Valid-until and refresh triggers

This parity plan expires 2026-08-05. Refresh earlier if:
- new datasets enable direct measurement of transmission fidelity or transformation biases for a chosen domain, [S28] [S22]
- a major new synthesis materially changes the framing landscape, or [S01]
- platform access changes invalidate the tractability assumptions for online proxies. [S01]

