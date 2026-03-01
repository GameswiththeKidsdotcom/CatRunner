---
name: Simulator always current build
plan_id: SimulatorCurrentBuild
overview: "Ensure every manual run of CatRunner in the iOS Simulator uses the most current built version: document workflow (Xcode Run / optional script) and add optional build-install-launch script. Blaster pipeline applied; ready for Lane A."
todos: []
isProject: false
---

# Simulator always current build

**Next hand off — Lane A:** Execute **C1 (Documentation)** per [C1-Doc.plan.md](C1-Doc.plan.md): add "Manual simulator testing" section to docs (e.g. app-store-readiness.md) and optional one-liner in Agents/tester.md. Then **C2 (Optional script)** per [C2-Script.plan.md](C2-Script.plan.md): add `ios/run-simulator.sh` and npm script `ios:simulator`. Agent: **generalPurpose**.

---

## Goal

When you make code changes and try CatRunner in the simulator, the simulator must run the **latest built** version so you don’t miss testing scenarios or report bugs that don’t exist. Root cause: the simulator runs whatever `.app` is installed; launching from the simulator home screen or without building first uses a stale build.

## Scope

- **In scope:** `docs/` (new section); optionally `Agents/tester.md` (one-line reminder); optionally `ios/run-simulator.sh` and `package.json` (npm script). No game logic or CI changes.
- **Out of scope:** Changing Xcode scheme behavior; CI (already builds fresh).

## Build chunks

| Chunk | Description | Agent | Conf (root) | Conf (solution) | Note |
|-------|-------------|--------|-------------|-----------------|------|
| C1 | [C1-Doc.plan.md](C1-Doc.plan.md) — Manual simulator testing: doc section + optional tester.md reminder | generalPurpose | 95% | 95% | Problem and workflow clear; rollback = revert doc. |
| C2 | [C2-Script.plan.md](C2-Script.plan.md) — Optional: build-install-launch script + npm script | generalPurpose | 95% | 92% | Bundle ID and paths verified; rollback = remove script. |

## Validation

- **C1:** Doc states: use Xcode Run (⌘R) or run-simulator script; avoid launching from simulator home screen unless you just built.
- **C2:** From repo root, `npm run ios:simulator` builds, installs, and launches app on booted simulator; after a code change, rerun and confirm new behavior.

## Risks and rollback

- **Doc:** Revert doc edit. **Script:** Remove script and npm script; no impact on Xcode or CI.

## Confidence (Blaster validation)

- **Root cause:** 95% — Simulator runs last installed build; not auto-updating. Evidence: CI builds then runs; local launch from icon = stale.
- **Solution path:** 95% — Build before run (Xcode Run or script); document and optionally automate.

## References

- [Master-Plan](../../Master-Plan.md) — Next hand off, Lane A
- [docs/app-store-readiness.md](../../../docs/app-store-readiness.md) — Placement for "Manual simulator testing"
- [Agents/tester.md](../../../Agents/tester.md) — Optional one-line reminder
- [ios/CatRunner.xcodeproj/project.pbxproj](../../../ios/CatRunner.xcodeproj/project.pbxproj) — PRODUCT_BUNDLE_IDENTIFIER = com.catrunner.game
