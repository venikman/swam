# Context notes extracted from the 2026-02-01 deck (Levencuk)

These notes are **not authoritative**; treat as context for workflow design.

Key claims / themes:
- AI agents make **solution generation cheap**; the bottleneck shifts to **problem framing** and multi-criteria acceptance specs.
- Winning looks like: design the problem, define quality characteristics, spend budget across a portfolio (not a single “best”).
- Use an explicit cycle: problem framing → acceptance spec → generate variants → parity compare → decide + record (ADR) → deploy reversibly → measure impact.
- Prefer portfolios / Pareto frontiers over scalar “rankings”.
- Long-horizon autonomy needs: external memory (files), audit trails, budgets/rights, and restartable checkpoints.

Why it matters here:
- A memetics research sprint can run for hours only if it is **checkpointed**, with stable artifacts and an explicit “resume protocol”.
