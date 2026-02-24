---
name: P001-SpecGaps — Ideation through implementation
overview: Detailed plan from ideation (spec vs app gap analysis + ideation review) through implementation for the one remaining spec violation (first-revive-only) and optional Tier 4 items. Baked into Master-Plan; Lane A (ios/) only for code.
---

**Next hand off (cut & paste):** First-revive-only **complete.** Next = **Tier 4** per Master-Plan. Invoke **Logic-Test** for state-machine validation per [e2e-spec-journeys.plan.md](e2e-spec-journeys.plan.md) §6.1 (allowed moves, unreachable states, state consistency after revive and second game over). Then execute Tier 4 (Monetization stub C8; in-game score HUD if not in Tier 2; optional 5-iPhone E2E, lane accessibility IDs).

---

# P001-SpecGaps — Ideation through implementation

## Scope

- **Goal:** Close the remaining spec vs application gap (first-revive-only per SPECIFICATION.md §1) and document the ideation→implementation path; optional Tier 4 items (in-game HUD, asset overlays) deferred.
- **Features:** Revive economy (one revive per run); spec/doc alignment.
- **Objects:** GameScene state (`hasRevivedThisRun`), GameViewController alert branching, E2E journey J4.

## Feature → object map

| Feature | Objects | Dependency order |
|--------|---------|-------------------|
| First-revive-only (spec §1) | GameScene.hasRevivedThisRun, GameViewController.showReviveOrGameOver branch, reset on startNewGame/resume/Play again | State flag first; then VC branch; then reset points |
| E2E J4 (second game over) | JourneyTests: add test path first game over → Watch ad → second game over → no Watch ad | After iOS behavior implemented |
| Logic-test state machine | Logic-test agent: validate allowed moves, no unreachable states, state after revive/play again | After code + E2E updated |

## Phases (sub-plans)

| Phase | Description | Sub-plan | State |
|-------|-------------|----------|--------|
| **1 — Ideation** | Gap analysis (spec vs app) + ideation review (Quick MVP / Scalable / Innovative). Quick MVP chosen: fix spec violation + doc. | Reference: spec vs app feature gaps plan (gap analysis); [Agents/ideation.md](../../../Agents/ideation.md) three approaches (Quick MVP chosen). | Done |
| **2 — First-revive-only (build)** | Implement hasRevivedThisRun; gate "Watch ad"; reset on new run. | [spec-gaps-first-revive-only.plan.md](spec-gaps-first-revive-only.plan.md) | **Done** (2026-02-24) |
| **3 — Test checkpoint** | Logic-Test + E2E J4 second-game-over path; 65 tests (58 unit + 7 UI). | Same sub-plan § Validation | **Done** (65 tests pass; J4c added; Logic-Test handoff below) |
| **4 — Deferred (Tier 4)** | In-game score HUD, asset-based game-over/revive overlays (implementation-spec). | Not started; listed in Master-Plan Tier 4. | Deferred |

## Master-Plan and hand off

- This plan is registered in the Master-Plan Plan Matrix as **P001-SpecGaps**.
- **Next hand off — Lane A:** **Tier 4** (see Master-Plan). Invoke Logic-Test per §6.1 for first-revive-only state machine; then execute Tier 4 deliverables.
- **Lane B:** No change (config/assets only).

## Risks and rollback

- **Risk:** E2E J4 may assume "Watch ad" on every game over. **Mitigation:** Add second-game-over test path; update J4 assertions.
- **Rollback:** Revert GameScene + GameViewController changes; keep "Watch ad" whenever monetization configured until tests updated.

## Checkpoint delegation

- **After first-revive-only code and 64 tests pass:** Invoke **Logic-Test** agent to validate revive/game-over state machine per [e2e-spec-journeys.plan.md](e2e-spec-journeys.plan.md) §6.1 (allowed moves, no unreachable states, state consistency after revive and play again).
- **E2E:** Lane A (or Tester) adds/updates J4 in `ios/CatRunnerUITests/JourneyTests.swift` for second game-over path (no "Watch ad"); run CatRunnerUITests as part of 64-test suite.

## References

- [docs/SPECIFICATION.md](../../../docs/SPECIFICATION.md) §1 (revive), §9 (monetization)
- [.cursor/Plans/Master-Plan.md](../../Master-Plan.md) — Tier 2 done; Tier 3 next; this plan bridges remaining spec violation
- [e2e-spec-journeys.plan.md](e2e-spec-journeys.plan.md) §6.1 (logic-test targets), J4 (revive flow)
- [Agents/ideation.md](../../../Agents/ideation.md) — Three approaches (Quick MVP chosen)
- [Agents/planner.md](../../../Agents/planner.md) — Decomposition, hand off, test checkpoints
