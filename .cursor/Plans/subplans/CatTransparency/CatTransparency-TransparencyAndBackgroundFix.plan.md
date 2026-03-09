# Cat Transparency and Background Fix

**Next hand off (cut & paste) — Lane A:** Execute **App Store submission** per docs/app-store-readiness.md; or **SeamlessBackground C2** (object integration) when C1 (background assets) done. Plan: [Tier7-AppStoreSubmission.plan.md](../../Tier7-AppStoreSubmission/Tier7-AppStoreSubmission.plan.md) or [C2-ObjectIntegration.plan.md](../../SeamlessBackground/C2-ObjectIntegration.plan.md). Agent: **generalPurpose**.

**Complete (2026-03-09).** C1 (script extend) and C2 (PlayerNode .clear) done; committed and pushed fc507e5. Lane B = SeamlessBackground C1.

---

**Plan ID:** CatTransparency  
**Scope:** Fix idle/jump/slide transparency; PlayerNode color; background-scroll consideration.

---

## Investigator Review (Step 1) — Confidence

| Section | Conf (root cause) | Conf (solution path) | Note |
|---------|-------------------|----------------------|------|
| Idle opaque (cat_run.png) | 98% | 95% | Verified hasAlpha: no; script extension trivial |
| Jump flash (tolerance/color) | 92% | 93% | systemTeal can tint; .clear aligns with obstacles |
| Script extension | N/A | 95% | Add 3 patterns; existing logic handles per-image corners |
| PlayerNode color | 95% | 95% | runTexture != nil ? .clear : .systemTeal; tests use nil |
| Background scroll | 85% | N/A | Hypothesis only; no code change in plan |

**Gate:** All sections >90% confidence. Proceed.

---

## Build Chunks

| Chunk | Description | Lane | Conf (root) | Conf (solution) |
|-------|-------------|------|-------------|-----------------|
| **C1** | Extend transparency script to cat_run.png, cat_jump.png, cat_slide.png; run on all 19 files | B | N/A | 95% |
| **C2** | PlayerNode: use .clear when runTexture present | A | 95% | 95% |
| C3 | Optional: re-run with --tolerance 20/30 if flash persists | B | N/A | 90% |
| C4 | Investigation: background tile seams if flash persists | — | 85% | N/A |

---

## Chunk Sub-Plans

- [C1-ScriptExtend.plan.md](C1-ScriptExtend.plan.md)
- [C2-PlayerNodeClear.plan.md](C2-PlayerNodeClear.plan.md)

---

## Test Plans (Step 2 — Blaster pipeline)

**ui-test:** Manual visual validation: idle cat has no visible box; jump/slide have no or reduced flash. No new E2E; existing JourneyTests cover gameplay. No viewport-specific changes.

**logic-test:** No game-logic change. C7MechanicsCollisionTests use PlayerNode() (nil texture); still get .systemTeal. No change to collision or state machine.

**infrastructure:** No change. Script runs locally; assets in repo. No CI/CD changes.

**e2e-harness:** Existing JourneyTests (J1–J5) cover gameplay; no new user journey required for transparency fix.

---

## Step 3: Investigator reconcile

Test-plan and infrastructure outcomes from Step 2: no changes required. Plan already accounts for manual visual validation, no logic-test changes, no infra changes. Reconcile complete.

---

## Step 4: Planner chunking

Plan broken into C1 (script extend), C2 (PlayerNode clear), C3 (optional tolerance tune), C4 (background investigation). C1 and C2 are build chunks; C3 and C4 are optional/follow-up.

---

## Step 5: Per-chunk fidelity

| Chunk | Investigator | ui-test | logic-test | infrastructure | e2e-harness | ui-designer |
|-------|--------------|---------|------------|----------------|-------------|-------------|
| C1 | Validated (95% solution) | Manual visual | N/A | N/A | N/A | N/A (post-process, not generate) |
| C2 | Validated (95% both) | Manual visual | No change | N/A | N/A | N/A |

---

## Validation

- `sips -g hasAlpha assets/character/cat_run.png` → `hasAlpha: yes`
- In-game: idle transparent; jump/slide reduced or no flash
- Unit tests pass

---

## Rollback

- Restore PNGs from git
- Revert PlayerNode color change
