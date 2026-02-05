# Hypothesis Portfolio (≥12) + Pareto Frontier

- Date: 2026-02-05 [S03]
- Valid-until: 2026-08-05 (refresh triggers: major new datasets; major new syntheses; platform access changes affecting proxy feasibility). [S01]
- Selection discipline: Pareto-only; no scalar collapse; no ordinal averaging as interval. [S01] [S02]
- Indicator set: I1–I8 (ADR-004; defined in `work/memetics_map.md`). [S02]

## 1) Conventions

### 1.1 Indicator levels
Levels used below:
- For I1–I7: `H > M > L`, plus `U = unknown/not yet evidenced`.
- For I8 (ethical/safety risk): `L < M < H` (lower is better), plus `U`.

Unknown values are *not* silently penalized; dominance is only asserted when comparisons are valid under this partial order. [S02] [S01]

### 1.2 Framing tags
- F1 = Memetics-as-replicators [S28]
- F2 = Dual-inheritance / cultural evolution [S14]
- F3 = Epidemiology / cultural attraction [S18] [S22]

## 2) Candidate hypothesis set (H01–H12)

Each hypothesis is written as a testable claim template. Evidence anchors are given as `[S##]`; these anchors motivate the hypothesis but do not guarantee truth. [S01]

### Summary table

`Vec` column encodes the indicator vector as: `I1 I2 I3 I4 I5 I6 I7 I8`.

| ID | Hypothesis (testable claim template) | Framings | Minimal observable / test handle | Vec | Evidence anchors |
|---|---|---|---|---|---|
| H01 | In an online diffusion context, **limited attention** plus network structure is sufficient to generate highly unequal popularity/persistence distributions for proxy “memes,” without assuming intrinsic value differences. | F2,F1 (proxy) | Fit/compare attention-limited diffusion model on a hashtag stream. | `M H M M H H H L` | [S24] |
| H02 | For behaviors requiring **reinforcement**, adoption probability increases with the number of independent exposures (complex contagion), and clustered networks outperform random networks for diffusion. | F2,F3 | Estimate exposure-response curves and topology effects in observational or experimental networks. | `M M H M M H M L` | [S26] |
| H03 | **Proxy choice changes conclusions**: operationalizing “meme” at different resolutions (hashtag vs phrase vs image-template) yields materially different competition/lifespan estimates in the same platform dataset. | F2,F1 (proxy) | Re-run the same pipeline with multiple unit definitions; quantify sensitivity. | `H H M H M M H L` | [S24] [S28] |
| H04 | Under repeated human transmission, variants converge toward **cultural attractors** (systematic transformations), and this convergence pattern is detectable as reconstruction bias rather than high-fidelity copying. | F3,F2 | Iterated reproduction/retelling experiment; measure convergence. | `M M H H M H M L` | [S22] [S29] [S28] |
| H05 | “Culture” is a **graded property**: measures of inter-individual similarity/stability show a continuum between “more individual” and “more cultural” information, not a sharp boundary. | F3,F2 | Define a graded “culturalness” index from similarity + prevalence; test for continuity. | `M M M M U M M L` | [S29] |
| H06 | Strong memetics-as-replicator claims become empirically meaningful **only when** unit identity and fidelity are operationalized; otherwise “meme” collapses into a near-trivial gloss (weak definition). | F1 | Compare predictive success/clarity across strong vs weak operationalizations in the same domain. | `H M M H M M M L` | [S28] |
| H07 | In online diffusion data, adding **attention constraints** improves out-of-sample prediction of persistence relative to models that omit attention (within the same proxy definition). | F2,F1 (proxy) | Train/test predictive models with/without attention terms; compare predictive error. | `M H M H H H H L` | [S24] |
| H08 | Some “internet meme” sharing behaviors are **complex contagions**: sharing probability shows threshold-like dependence on repeated exposures rather than simple contagion dynamics. | F2,F3 | Estimate exposure thresholds for sharing events using time-ordered exposure logs. | `M H H M M H M L` | [S26] |
| H09 | In domains where transmission is strongly **transformative**, “selection” explanations (copy + differential retention) will underperform “attraction” explanations (systematic convergence) on explanatory clarity and falsifiability. | F3 vs F1 | Model comparison: copying/selection vs transformation/attraction; compare fit + falsifiers. | `M M H M M M M L` | [S22] [S28] |
| H10 | Increasing the rate of novel content introduction increases **competition for finite attention** and shortens the median lifetime of proxy “memes,” holding network size constant. | F2,F1 (proxy) | Test association between content supply rate and meme lifetimes. | `M H M M M H H L` | [S24] |
| H11 | Memetics-as-replicators (F1) is a **special case** of cultural evolution (F2) that becomes plausible only in bounded contexts with high preservative transmission; domains can be classified along a preservative↔constructive axis. | F1,F2,F3 | Build a domain classifier using transformation/fidelity indicators; test where F1 yields predictive gains. | `M M M M M M M L` | [S28] [S29] [S14] |
| H12 | In an epidemiology-of-representations view, distributions of cultural variants are shaped by **cognitive plausibility constraints** (systematic transformation biases), yielding convergent patterns across transmission chains. | F3 | Identify recurrent transformation patterns and convergence in transmission datasets/experiments. | `M M H M U M M L` | [S18] [S22] |

Notes:
- H01/H07/H10 are close variants; they are kept separate because they target different observables (distributional sufficiency vs predictive leverage vs content-supply effects). [S24]
- H09/H11 are bridge hypotheses about scope conditions and framing dominance; they are expected to remain partially uncertain until a bounded domain is chosen. [S28] [S22]

## 3) Pareto pruning (≈5–7 frontier items)

### 3.1 Declared objective (v0.1)
Keep hypotheses that jointly maximize:
- empirical tractability with accessible proxies (I2, I7), [S24]
- mechanism specificity and falsifiability (I4, I6), [S01] [S02]
- explicit handling of copying vs transformation disputes (I3), [S28] [S22]
while respecting the safety boundary (I8). [S01]

### 3.2 Frontier set (v0.1; robust non-dominated under coarse rubric)

Frontier candidates (6):
- **H03 (Proxy sensitivity):** high unit explicitness + tractability; directly addresses “proxy≠ontology” risk. [S24] [S28]
- **H07 (Attention improves prediction):** high tractability + predictive leverage in the online anchor domain. [S24]
- **H08 (Complex contagion for meme sharing):** imports a strong mechanism from complex contagion into a memetics-adjacent online behavior question. [S26]
- **H04 (Attractor convergence under transmission):** directly tests the transformative transmission objection central to memetics critiques. [S22] [S29] [S28]
- **H06 (Strong vs weak meme operationalization):** makes the “meme is substantive vs trivial” critique empirically actionable. [S28]
- **H11 (F1 as special case classifier):** bridges framings; aims to map where replicator models are plausible vs dominated. [S28] [S29] [S14]

This set is intentionally diverse across framings and data modalities (online traces vs transmission experiments vs meta-operationalization). [S01] [S02]

### 3.3 Non-frontier items (kept as alternates; not deleted)

These are not “bad”; they are *currently* dominated or too uncertain for v0.1 given the indicator set and pinned bounded context.

- **H01 vs H07:** H01’s “sufficiency” claim is broader and more contestable, while H07 targets a more directly testable predictive comparison using the same evidence base; H01 is therefore deferred as “harder version” of H07. [S24]
- **H02 vs H08:** H02 is close to the established complex contagion claim in the anchor source; H08 adapts the mechanism to a memetics-adjacent behavior (sharing), increasing novelty while retaining testability. [S26]
- **H05 and H12:** both depend on additional measurement work to operationalize representation-level constructs (latent variables) and are kept as “microfoundation deepening” alternates. [S18] [S29]
- **H09 and H10:** both are plausible but either (a) require careful model class commitments (H09) or (b) require stronger control/identification to avoid confounding (H10); kept as follow-ups once the data window is pinned. [S22] [S24]

## 4) Explicit uncertainties (do not hide)

- Unknown: which bounded contexts exhibit sufficient preservative transmission for strong replicator-style memetics to be predictively superior (this is exactly what H11 targets). [S28] [S29]
- Contested: whether selection language adds explanatory clarity beyond attraction/transformative models in many domains (H09 is the comparative test template). [S28] [S22]
- Measurement risk: many key constructs (representation identity, attractor strength, fidelity) require explicit measurement templates to avoid equivocation. [S02] [S22] [S28]

