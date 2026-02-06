---
name: checkpoint
description: Use at end of a run or when blocked. Creates ONE new work/checkpoints/<YYYYMMDD-HHMM>.md and updates work/STATE.md (last checkpoint + delta + next actions).
---

# Checkpoint (End-of-Run)
1) Pick a timestamp in `YYYYMMDD-HHMM` (local time). If a file already exists for that minute, increment the minute until you get a unique filename.

2) Write exactly ONE new checkpoint file: `work/checkpoints/<TIMESTAMP>.md`
   - What changed (2–6 bullets; include files touched)
   - Evidence added (links + where recorded)
   - Decisions made (and why; include ADR refs if updated)
   - Next actions (3–7 bullets, ordered)

3) Update `work/STATE.md`
   - Update `Last checkpoint:` to `<TIMESTAMP>`
   - Update `Deliverables status:` with what’s done vs missing
   - Replace `Next actions` with the same 3–7 ordered items

4) Stop.
