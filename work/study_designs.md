# Study Designs (Frontier Items)

- Date: 2026-02-05 [S03]
- Valid-until: 2026-08-05 (refresh triggers: new datasets, new access constraints, new key syntheses, or revised frontier). [S01]
- Inputs: frontier sets in `work/hypothesis_portfolio.md` and `work/problem_portfolio.md` (ADR-005). [S01]
- Safety: observational/measurement-first only; no manipulation playbooks or targeted persuasion guidance. [S01]

## 0) Overview: Frontier-to-Study Mapping

| Study ID | Primary problems | Primary hypotheses | Core framings exercised |
|---|---|---|---|
| SD1 | P01 | H03, H06 | F2 (+ F1 as proxy operationalization) [S24] [S28] |
| SD2 | P02 | H07 (and optionally H01/H10 as extensions) | F2 (+ proxy operationalization) [S24] |
| SD3 | P03 | H08 | F2/F3 mechanism test (reinforcement thresholds) [S26] |
| SD4 | P04 | H04 | F3 (attraction) with explicit copying-vs-transformation tests [S22] [S29] |
| SD5 | P05 | (supports H04/H06/H11) | Cross-framing measurement templates (copying vs re-production axis) [S28] [S29] |
| SD6 | P06 | H11 (and H06) | Cross-framing scope classifier (when F1 is special case) [S28] [S14] |

Each study below includes: framing + “meme” construct declarations, dataset/data collection options, variables, analysis plan, confounders/threats, falsifiers, and ethics/safety notes. [S01] [S28]

## SD1: Unit/Proxy Sensitivity Analysis (Multi-Resolution “Meme” Definitions)

- Related portfolio items: P01; H03; H06. [S24] [S28]
- Framings: F2 (variants/distributions) with explicit proxy discipline; optionally interpret as F1 proxy-meme operationalization (Meme-C). [S24] [S28]
- “Meme” construct(s) tested: Meme-C (operational proxy) plus strong-vs-weak operationalization contrast (H06). [S28] [S24]

### Data / collection plan (bounded options)
Data requirements (minimal):
- time-stamped posts/events with content tokens (enables alternative unit definitions),
- an observable “transmission” event type (e.g., reshare/retweet/repost) if studying diffusion,
- optional: follower graph / interaction graph for exposure estimation. [S24]

Candidate sources (choose one; record as a bounded-context decision in ADR before execution):
- A: reuse a dataset structurally similar to the hashtag-based proxy setting in Weng et al. (hashtags as memes; retweets as transmission events). [S24]
- B: use any public, time-stamped corpus of reshares with tokenizable content where unit definitions can be varied (proxy discipline applies). (Inference; dataset choice must be documented.) [S24] [S01]

### Variables / operationalization
- Unit definitions (multiple):
  - U1: hashtags as units (proxy) [S24]
  - U2: n-gram phrases as units (proposed; inference)
  - U3: image-template clusters as units (proposed; inference)
- Outcome measures (per unit definition):
  - lifespan (first-to-last observed time),
  - popularity (total count),
  - persistence (survival metrics),
  - competition metrics conditioned on attention proxies (optional; aligns with SD2). [S24]

### Analysis plan (minimal)
1. Define a fixed data window and sampling rule (pinned). [S01]
2. Extract units under U1/U2/U3 with explicit boundary rules (avoid equivocation). [S28]
3. Compute outcome measures per unit definition.
4. Quantify sensitivity:
   - rank-order stability across U1/U2/U3 (ordinal comparisons only),
   - distributional shifts (qualitative + descriptive statistics; no single composite). [S02]
5. Report which conclusions are robust vs proxy-dependent. [S02] [S24]

### Confounders / threats to validity (examples)
- Ambiguous unit identity across resolutions (exactly what is being measured). [S28]
- Platform/channel effects: unit observability depends on the data channel used. [S24]

### Falsifiers / decision hooks
- If key conclusions (e.g., “competition intensity” or “top memes”) flip substantially across plausible unit definitions, then any memetics claim relying on that proxy must be scoped as proxy-dependent. [S24] [S28]
- If conclusions remain stable across multiple unit definitions, proxy risk is reduced for the bounded context (does not establish ontological identity). [S24]

### Ethics/safety
- Use only observational/archival data; avoid targeted interventions. [S01]
- Publish only aggregated statistics and avoid personally identifying information. (Inference; governance requirement.) [S01] [S02]

## SD2: Attention-Limited Prediction (Diffusion Under Finite Attention)

- Related portfolio items: P02; H07 (optionally H01/H10 as follow-on tests). [S24]
- Framings: F2 (population-thinking models of socially learned information) with proxy “meme” operationalization (Meme-C). [S14] [S24]
- “Meme” construct: Meme-C (operational proxy, e.g., hashtags). [S24]

### Data / collection plan
Same minimal requirements as SD1, plus:
- an attention proxy per user/time window (e.g., limited “capacity” to attend to memes as modeled in Weng et al.). [S24]

### Variables / operationalization
- Attention proxy candidates (must be explicitly declared; do not treat as ground truth):
  - finite “active meme” slots per user/time (as in attention-limited modeling), [S24]
  - observed posting/reshare volume as a proxy for attention allocation (proposed; inference). [S24]
- Outcomes:
  - persistence/lifespan prediction,
  - popularity prediction (counts). [S24]

### Analysis plan (minimal)
1. Fit two model classes on the same window:
   - M0: baseline diffusion model without attention constraint,
   - M1: attention-limited diffusion model (attention term(s) included). [S24]
2. Compare out-of-sample predictive performance (e.g., held-out time windows). (Inference; the evaluation metric must be declared.) [S01] [S24]
3. Report performance as multiple measures (do not collapse). [S02]

### Confounders / threats to validity
- Attention proxies may be misspecified (proxy≠latent attention). [S24]
- Exposure is hard to estimate without network data (if exposures are required). [S24]

### Falsifiers / decision hooks
- If M1 does not improve prediction over M0 under reasonable evaluation choices, the “attention constraint” mechanism is weakened for the bounded context. [S24]
- If M1 improves prediction but only under one proxy definition (SD1), then conclusions are proxy-dependent and must be scoped accordingly. [S24] [S28]

### Ethics/safety
Observational only; avoid designs that attempt to manipulate attention. [S01]

## SD3: Complex Contagion Thresholds for Meme-Adjacent Sharing

- Related portfolio items: P03; H08. [S26]
- Framings: F2/F3-compatible mechanism test (reinforcement thresholds; constructive adoption). [S26] [S29]
- “Meme” construct: typically Meme-C (observable adoption/sharing event as proxy), but must be explicitly defined per domain. [S26] [S28]

### Data / collection plan (two options)
- Option A (experimental): build an online-network experiment structurally similar to Centola’s design to directly observe reinforcement effects. [S26]
- Option B (observational): use time-ordered exposure logs in a bounded platform context to estimate exposure-response curves. (Inference; feasibility depends on data access.) [S26] [S01]

### Variables / operationalization
- Exposure count: number of independent adopter neighbors (or distinct sources) prior to adoption. [S26]
- Adoption/sharing event: binary or time-to-event.
- Network topology: clustered vs random (experimental) or measured clustering coefficient (observational). [S26]

### Analysis plan (minimal)
1. Estimate adoption probability/hazard as a function of exposure count.
2. Test for threshold-like nonlinearity consistent with complex contagion vs simple contagion. [S26]
3. Compare diffusion outcomes across topologies (if experimental) or across high/low clustering subgraphs (if observational; inference). [S26]

### Confounders / threats to validity
- Homophily and common-cause confounding in observational exposure estimates. (Inference; must be addressed if using Option B.) [S01]
- Measurement error in exposure (unobserved exposures). (Inference.) [S01]

### Falsifiers / decision hooks
- If adoption probability is well-explained by single exposure with no reinforcement effect, the complex-contagion mechanism is not supported for that behavior in that context. [S26]

### Ethics/safety
- Experimental option requires informed consent and clear debriefing; avoid sensitive content domains. (Inference; governance requirement.) [S01]

## SD4: Iterated Transmission Experiment to Detect Cultural Attractors

- Related portfolio items: P04; H04. [S22] [S29]
- Framings: F3 primary (attraction/transformative transmission) with explicit comparison to preservative-copy expectations. [S22] [S28]
- “Meme” construct: Meme-A vs alternative (strong replicator claim vs transformation model) is tested as an empirical contrast. [S28] [S22]

### Data / collection plan
Design an iterated transmission experiment:
- Seed participants with initial variants (stories, drawings, descriptions).
- Run multiple independent transmission chains (“generations”).
- Record outputs at each generation; code features. (Inference; standard approach aligned with attraction concept.) [S22] [S29]

### Variables / operationalization
- Feature representation of each transmitted item (coding scheme must be declared; inter-rater reliability recorded). (Inference; audit requirement.) [S01] [S02]
- Similarity metrics between generations (e.g., feature overlap; edit distance as proposed). (Inference.)
- Attractor convergence: convergence toward a stable variant cluster across chains. [S22]

### Analysis plan (minimal)
1. Measure within-chain change vs between-chain convergence.
2. Estimate whether transformations are random drift (no convergence) versus biased reconstruction (convergence). [S22] [S29]
3. Compare explanatory adequacy of:
   - preservative copying expectation (strong replicator-style), vs [S28]
   - attraction/convergence expectation. [S22]

### Confounders / threats to validity
- Coding scheme choice can create artificial “attractors” (measurement artifact). (Inference; mitigated by preregistered coding rules.) [S01] [S02]
- Participant prior knowledge can bias transformations (may be desired signal; must be measured/controlled). (Inference.) [S18]

### Falsifiers / decision hooks
- If multiple chains preserve features with high fidelity and show little systematic convergence beyond copying, then strong transformation/attractor explanations are weakened for that task. [S22] [S28]
- If chains systematically converge to similar outputs despite diverse inputs, attraction-style explanation is supported for that task. [S22]

### Ethics/safety
Use benign stimuli; avoid political/targeted persuasion content. [S01]

## SD5: Measurement Templates for Copying vs Re-Production (Transmission Mode Axis)

- Related portfolio items: P05 (supports SD1–SD4; also supports H11/H06). [S28] [S29]
- Framings: cross-framing; explicitly targets the key objection that many cultural items are re-produced (constructed) rather than copied. [S28] [S29]

### Output of this study design (a “methods artifact”)
Produce a measurement template bundle:
- `T_fidelity`: measures preservative copying (proposed; inference),
- `T_transformation`: measures systematic reconstruction (proposed; inference),
- `T_convergence`: measures attractor-like convergence across chains. [S22]

### Data sources
- Use SD4 iterated-transmission outputs (preferred) and/or SD1/SD2 online proxy traces where transformation can be meaningfully defined. [S24] [S22]

### Measurement templates (minimal; propose + validate)
- `T_fidelity` (ordinal/ratio depending on coding):
  - define feature set,
  - compute feature preservation across generations. (Inference; tied to the “replication” requirement for strong memes.) [S28]
- `T_transformation` (qual/ordinal):
  - categorize transformation types (add/remove/substitute/normalize),
  - compute transformation bias frequencies. (Inference.) [S22]
- `T_convergence` (ordinal/ratio):
  - compute cross-chain similarity increase over generations,
  - compare to a null model (random drift). [S22]

### Validation plan
- Inter-rater reliability for feature coding (auditability). [S01] [S02]
- Sensitivity analysis: show how template results change under plausible alternative codings (connect to SD1 proxy sensitivity discipline). [S28] [S02]

### Ethics/safety
Measurement-only; publish aggregated results and coding schemes without subject-identifying data. [S01]

## SD6: Domain Classifier for “When Is Memetics-as-Replicators a Special Case?”

- Related portfolio items: P06; H11; H06. [S28] [S14]
- Framings: bridges F1/F2/F3 by treating F1 as potentially valid only in bounded contexts with sufficient preservative transmission. [S28] [S29]

### Data / collection plan
Select multiple bounded domains (at least two) that plausibly differ on preservative↔constructive transmission:
- D1: online token diffusion (proxy memes), [S24]
- D2: iterated human transmission task (SD4). [S22] [S29]

### Variables / operationalization
- For each domain, estimate transmission-mode measures using SD5 templates. [S28] [S22]
- Define a domain-level “preservative vs constructive” profile (ordinal). [S29]

### Analysis plan (minimal)
1. For each domain, test whether a strong replicator-style operationalization (F1 strong meme construct) yields additional predictive/explanatory leverage beyond a broader F2/F3 framing under the same data window. [S28] [S14]
2. Map domains into a small taxonomy:
   - “F1 plausible special case” vs “F1 dominated by attraction/distributional models”, with explicit uncertainty labels. [S02]

### Confounders / threats to validity
- The taxonomy can be an artifact of measurement templates (mitigate via SD1-style sensitivity analyses). [S28] [S02]

### Falsifiers / decision hooks
- If domains with high measured transformation still show clear benefits from strong replicator modeling (unexpected), then the “F1 special case requires preservative transmission” hypothesis is weakened. [S28] [S29]
- If strong replicator modeling provides no added value even in high-fidelity contexts (as measured), then F1 is likely dominated for this repo’s acceptance criteria. [S28] [S01]

### Ethics/safety
Keep domain choice away from sensitive/political targeting; publish only aggregated domain-level conclusions and transparent measurement assumptions. [S01]

