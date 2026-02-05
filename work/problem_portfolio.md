# Problem Portfolio (≥12 Research Questions) + Pareto Frontier

- Date: 2026-02-05 [S03]
- Valid-until: 2026-08-05 (refresh triggers: new datasets/tooling; major syntheses; platform access changes). [S01]
- Selection discipline: Pareto-only; no single-score rankings; no ordinal averaging as interval. [S01] [S02]
- Indicator set: I1–I8 (ADR-004; defined in `work/memetics_map.md`). [S02]

## 1) Conventions

### 1.1 Indicator levels
Levels used below:
- For I1–I7: `H > M > L`, plus `U = unknown/not yet evidenced`.
- For I8 (ethical/safety risk): `L < M < H` (lower is better), plus `U`.

Unknown values are first-class and must not be silently penalized. [S02] [S01]

### 1.2 Framing tags
- F1 = Memetics-as-replicators [S28]
- F2 = Dual-inheritance / cultural evolution [S14]
- F3 = Epidemiology / cultural attraction [S18] [S22]

## 2) Candidate problem set (P01–P12)

Each problem is a research question phrased to be operationalizable; it is not a claim of fact. Evidence anchors motivate why the problem matters. [S01]

### Summary table

`Vec` encodes `I1 I2 I3 I4 I5 I6 I7 I8` as in `work/hypothesis_portfolio.md`.

| ID | Research question / problem statement | Framings | Minimal test handle / data | Vec | Evidence anchors |
|---|---|---|---|---|---|
| P01 | How sensitive are “meme competition” conclusions to **unit/proxy definition** (hashtag vs phrase vs template) within the same platform data window? | F2,F1 (proxy) | Multi-resolution re-analysis of the same dataset. | `H H M H M M H L` | [S24] [S28] |
| P02 | Can an **attention-limited diffusion** model predict proxy meme persistence/popularity out of sample better than models omitting attention constraints? | F2,F1 (proxy) | Model comparison on hashtag diffusion streams. | `M H M H H H H L` | [S24] |
| P03 | Is sharing/adoption of selected meme-adjacent behaviors a **complex contagion** (reinforcement threshold), and how does network clustering change outcomes? | F2,F3 | Exposure-threshold estimation; topology comparison. | `M H H M M H M L` | [S26] |
| P04 | What measurable patterns indicate **cultural attractors** in iterated transmission, and how can we estimate “attractor strength” from repeated reconstructions? | F3,F2 | Iterated reproduction experiment; convergence statistics. | `M M H H M H M L` | [S22] [S29] |
| P05 | How can we operationalize and measure the preservative↔constructive **transmission mode** axis (copying vs re-production) in a bounded domain? | F1,F2,F3 | Define and validate fidelity/transformation measures for a dataset/experiment. | `H M H M M M M L` | [S28] [S29] [S22] |
| P06 | In which bounded contexts is memetics-as-replicators (F1) plausibly a **special case** of cultural evolution (F2), and how can we classify domains by transmission conditions? | F1,F2,F3 | Domain taxonomy + tests where F1 adds predictive gains. | `M M M M M M M L` | [S28] [S29] [S14] |
| P07 | How often can observed diffusion patterns be explained by **selection-like** dynamics versus **attraction-like** dynamics, and what empirical signatures distinguish them? | F1 vs F3 | Competing model templates; signature extraction. | `M M H M M M M L` | [S22] [S28] |
| P08 | What disambiguations of “**cultural attractor**” are practically useful for explanation and measurement in a chosen domain? | F3 | Conceptual analysis + measurement templates tied to disambiguated variants. | `H M M M U M L L` | [S22] |
| P09 | How can we measure “**graded culturalness**” (continuum between individual and cultural information) in observational data? | F3,F2 | Define a culturalness index; test for continuity and stability. | `M M M M U M M L` | [S29] |
| P10 | Does increased **content supply rate** shorten proxy meme lifetimes under finite attention constraints, controlling for network size/structure? | F2,F1 (proxy) | Regression/causal identification in time-series platform data. | `M H M M M H M L` | [S24] |
| P11 | Under what conditions does an attention-limited model explain heterogeneity **without intrinsic value differences**, and how do we test the “no intrinsic differences needed” claim? | F2,F1 (proxy) | Model comparison with/without content-feature terms. | `M H M M M M M L` | [S24] |
| P12 | How can surface proxies (tokens/traces) be linked to **representation-level** constructs in an epidemiology-of-representations framework, without reifying proxies as ontology? | F3 | Develop mapping assumptions + validation checks; identify required additional measures. | `M M M M U M L L` | [S18] [S24] |

## 3) Pareto pruning (≈5–7 frontier items)

### 3.1 Declared objective (v0.1)
Prefer problems that:
- are immediately testable with accessible online anchors (I2, I7), [S24]
- explicitly engage the copying↔transformation dispute (I3), [S28] [S22]
- have clear falsifiability hooks (I4) and mechanism specificity (I6), [S01] [S02]
while maintaining the safety boundary (I8). [S01]

### 3.2 Frontier set (v0.1; robust non-dominated under coarse rubric)

Frontier problems (6):
- **P01 (Unit/proxy sensitivity)**: measurement governance and robustness; high tractability. [S24] [S28]
- **P02 (Attention-limited prediction)**: strong online anchor with direct predictive test. [S24]
- **P03 (Complex contagion thresholds)**: strong mechanism + clear test handle. [S26]
- **P04 (Attractor detection in transmission)**: directly tests transformative transmission and provides a route to measure attraction. [S22] [S29]
- **P05 (Transmission mode measurement templates)**: foundational measurement work that supports multiple hypotheses and framings. [S28] [S29]
- **P06 (Domain classifier for F1 special-case)**: bridges framings and makes “when is memetics useful?” empirically addressable. [S28] [S14]

### 3.3 Non-frontier items (kept as alternates; not deleted)

- **P07** overlaps strongly with P04/P05 and is deferred until measurement templates exist to distinguish selection vs attraction signatures in the chosen domain. [S22] [S28]
- **P08** is important for conceptual clarity but is currently low on tractability (I7) until a bounded domain is selected; keep as a supporting thread. [S22]
- **P09** and **P12** are “microfoundation/representation” deepening tracks that likely require additional measurement work; keep as alternates. [S18] [S29]
- **P10** and **P11** are valuable online extensions but require stronger identification and careful controls; keep as second-wave once P01/P02 establish the measurement pipeline. [S24]

## 4) Explicit uncertainties and scope notes

- The frontier is **context-dependent**: if the bounded context shifts away from online diffusion proxies and toward cognitive reconstruction, the frontier will likely shift toward P04/P08/P12. [S18] [S22] [S24]
- Some problems (P04/P05/P12) require additional measurement templates to avoid proxy reification and equivocation. [S02] [S24] [S28]

