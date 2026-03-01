---
name: C2 — Optional run-simulator script
plan_id: C2
parent: SimulatorCurrentBuild
overview: "Add script that builds, installs, and launches CatRunner on booted simulator so one command always uses current version."
todos: []
isProject: false
---

# C2 — Optional run-simulator script

**Next hand off — Lane A:** Execute this chunk after C1: add `ios/run-simulator.sh` and npm script `ios:simulator`. Parent: [SimulatorCurrentBuild.plan.md](SimulatorCurrentBuild.plan.md). Agent: **generalPurpose**.

---

## Goal

One command from repo root: build → install → launch on the booted simulator, so "every time I try CatRunner" uses the just-built binary without opening Xcode.

## Steps

1. **Create `ios/run-simulator.sh`** (executable: `chmod +x`):
   - Build from `ios/`: `xcodebuild -scheme CatRunner -destination 'platform=iOS Simulator,name=iPhone 16,OS=latest' -configuration Debug -derivedDataPath build build`. Exit non-zero on build failure.
   - Ensure simulator is booted: e.g. use `xcrun simctl list devices | grep -q "iPhone 16.*Booted"` or boot "iPhone 16" if none booted.
   - Install: `xcrun simctl install booted ios/build/Build/Products/Debug-iphonesimulator/CatRunner.app` (path assumes run from repo root; if script runs from `ios/`, use `build/Build/Products/Debug-iphonesimulator/CatRunner.app`).
   - Launch: `xcrun simctl launch booted com.catrunner.game`.
   - Script may accept an optional device name (default iPhone 16); document in script or README.
2. **Add npm script** in `package.json`: `"ios:simulator": "cd ios && ./run-simulator.sh"` (or invoke script from root with correct path to .app). Ensure script is executable in repo.
3. **Document** in the "Manual simulator testing" section (C1): "Alternatively, run `npm run ios:simulator` from repo root."

## Technical details

- **Bundle ID:** `com.catrunner.game` (from `ios/CatRunner.xcodeproj/project.pbxproj`).
- **App path after build (from `ios/`):** `build/Build/Products/Debug-iphonesimulator/CatRunner.app`.
- **From repo root:** `ios/build/Build/Products/Debug-iphonesimulator/CatRunner.app`.

## Validation

- From repo root: `npm run ios:simulator` builds, installs, and launches the app on the simulator.
- Change a visible string in the app, run again, confirm the new content appears (confirms current build).

## Rollback

Remove `ios/run-simulator.sh` and the `ios:simulator` entry from `package.json`; no impact on Xcode or CI.

## Confidence

- **Confidence (root cause):** 95% — Same as parent; script is optional automation.
- **Confidence (solution path):** 92% — Paths and bundle ID verified; simulator name or boot state may need adjustment on some machines (document default and optional arg).

## References

- [SimulatorCurrentBuild.plan.md](SimulatorCurrentBuild.plan.md) — Parent plan
- [C1-Doc.plan.md](C1-Doc.plan.md) — Doc to update with script mention
- [ios/CatRunner.xcodeproj/project.pbxproj](../../../ios/CatRunner.xcodeproj/project.pbxproj) — PRODUCT_BUNDLE_IDENTIFIER
- [.github/workflows/test.yml](../../../.github/workflows/test.yml) — Reference destination for simulator name
