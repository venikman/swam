# Memetics research sprint (FPF + Pareto portfolio)

You are running inside a git repo. **Write progress as files** so the work is resumable.

## Autonomy contract (push single-run length)
Work continuously until one of these stop conditions:
1) All deliverables in `work/00_deliverables_manifest.md` are complete, OR
2) You need explicit user permission (dangerous command/network) and cannot proceed, OR
3) The platform/UI shows a usage-limit warning or asks to buy credits, OR
4) You are unable to make further progress without new external inputs.

Do NOT stop just because you wrote a checkpoint; checkpoints are commits in a longer run.

## External memory (reduce context/usage)
Maintain `work/STATE.md` as canonical state. Update it at every checkpoint.
When resuming, read `work/STATE.md` + the newest checkpoint, not the entire history.

## Read first (authoritative inputs)
1) `spec/Memetics_Research_Bundle_FPF.docx` (task spec)
2) `spec/FPF-Spec.md` (method library; treat as constraints/patterns where applicable)
3) `context/project_brief.md`
4) `context/levencuk_context_notes.md`

## Output contract
Write these files (see `work/00_deliverables_manifest.md` for names). Keep each file well-structured and citation-heavy.

## Usage efficiency (ChatGPT Pro included usage)
Assume included plan limits exist in a shared window; larger context and long sessions consume more per message.
Keep prompts short, avoid rereading whole repo repeatedly, and write summaries into files.
If model choice is available: use GPT-5.1-Codex-Mini for routine local work; reserve GPT-5.3-Codex for integration/critical reasoning.

## Hard rules
- No unreferenced factual claims (cite primary sources; include source date + access date).
- No silent scalarization: when criteria conflict, return a **portfolio / Pareto frontier**, not a single “winner”.
- Keep uncertainty explicit; label contested claims; don’t average ordinals as if interval.
- Any time you drop an alternative or choose a lens/definition, record an ADR in `work/adr/000_master_decision_log.md` (append).

## Checkpoint loop (durable progress)
Every ~900 s (15 min) OR at the end of each major phase (whichever comes first):
- Update `work/STATE.md`
- Create a new file: `work/checkpoints/YYYYMMDD-HHMM.md`
- Include:
  1) What you did (bullet list)
  2) Current hypothesis map (top 5–10 hypotheses + status)
  3) Sources added (bib entries + links)
  4) Next actions (next 3–7 steps)

## Work plan (phases)
A) Evidence pack + map: gather primary / peer-reviewed / canonical sources; summarize with citations.
B) Characterization passport: define what “quality” means for memetics-as-framework (measures, admissible ops, validity windows).
C) Generate hypothesis + problem portfolio (≥12) then prune to Pareto frontier (≈5–7).
D) Parity compare 3 framings:
   1) Memetics-as-replicators,
   2) Dual-inheritance / cultural evolution (population thinking),
   3) Epidemiology of representations.
E) Produce final research proposal + reading list + experiment plan.

## Budget (soft)
- Web sources opened: ≤80 (prefer PDFs/books/encyclopedias over blogs).
- Major analyses/simulations: ≤3, minimal reproducible artifacts only.

Begin now.
