---
name: C1 — Documentation (simulator always current)
plan_id: C1
parent: SimulatorCurrentBuild
overview: "Add 'Manual simulator testing' section so every run in simulator uses latest build; optional one-liner in tester.md."
todos: []
isProject: false
---

# C1 — Documentation (simulator always current)

**Next hand off — Lane A:** Execute this chunk: add "Manual simulator testing" to docs and optional reminder in Agents/tester.md. Parent: [SimulatorCurrentBuild.plan.md](SimulatorCurrentBuild.plan.md). Agent: **generalPurpose**.

---

## Goal

Document the rule: **always build before run** when testing in the simulator, so testers and agents don’t run a stale install.

## Steps

1. **Add "Manual simulator testing" section** to an existing doc testers use. Recommended: `docs/app-store-readiness.md` (e.g. under "Build and archive" or as its own subsection). Content:
   - **Preferred:** In **Xcode**, use **Run** (⌘R). That builds and installs to the selected simulator, then launches — so the run is always the latest build.
   - **Optional clean rebuild:** Product → Clean Build Folder (⇧⌘K), then Run (⌘R).
   - **Do not:** Rely on launching CatRunner by tapping its icon on the Simulator home screen **unless** you have just run from Xcode (or run the run-simulator script). That icon is the last installed build.
   - If C2 (script) is implemented: "Alternatively, run `npm run ios:simulator` from repo root to build, install, and launch on the booted simulator."
2. **Optional:** In `Agents/tester.md`, under the iOS tests section, add a one-line reminder: "When testing manually in simulator, always Run from Xcode (⌘R) or use the run-simulator script so the simulator uses the latest build." Link to the doc section above.

## Validation

- Doc contains the "Manual simulator testing" (or equivalent) text with the three bullets (Xcode Run; optional Clean; do not launch from icon unless just built).
- Optional: tester.md contains the one-line reminder and link.

## Rollback

Revert the doc (and tester.md) edit; no code or build impact.

## Confidence

- **Confidence (root cause):** 95% — Problem is clearly "simulator runs last installed build."
- **Confidence (solution path):** 95% — Documenting Xcode Run and optional script is sufficient; steps are verifiable.

## References

- [SimulatorCurrentBuild.plan.md](SimulatorCurrentBuild.plan.md) — Parent plan
- [docs/app-store-readiness.md](../../../docs/app-store-readiness.md) — Target doc
- [Agents/tester.md](../../../Agents/tester.md) — Optional reminder
