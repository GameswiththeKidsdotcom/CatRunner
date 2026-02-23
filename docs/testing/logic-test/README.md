# Logic-test — Game logic validation

Validation of game logic: allowed moves, state machine, revive/play-again, unreachable states. No separate test target; deliverables are validation docs and alignment with spec.

## Scope

- Allowed moves from each state (e.g. Revive, Play again, Done only from game-over).
- No unreachable valid states.
- State consistency after Revive (resume from checkpoint) and after Play again (new run, high score persisted).
- Rules from spec: one alert on instant-fail; Revive → resume; Done → dismiss; Play again → full run reset.

## Plans and deliverables

- [logic-test-revive-playagain-2026-02-23.md](../../../.cursor/Plans/subplans/P001/logic-test-revive-playagain-2026-02-23.md) — Logic-test deliverable for P001-E2E-Journeys; validation tables and issues.
- [C11-tests.plan.md](../../../.cursor/Plans/subplans/P001/C11-tests.plan.md) — Automated tests (unit target, CI).

## Agent

- **logic-test:** [Agents/logic-test.md](../../../Agents/logic-test.md) — Move validation, state-machine consistency, turn/phase rules.

## Spec (rules)

- [docs/SPECIFICATION.md](../../SPECIFICATION.md) — §1 (game concept, revive, CTAs), §3 (engine architecture), §4 (procedural generation).
