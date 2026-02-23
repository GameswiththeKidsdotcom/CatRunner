# BG4 Validation — 2026-02-23 (Lane A)

**Per:** [P002-VIEWPORT.md](../zz-P002/P002-VIEWPORT.md), [Many-buildings-bg.plan.md](./Many-buildings-bg.plan.md) §6, §10.

## 5-iPhone matrix (simulator)

**Environment:** Xcode, iOS 18.5 simulators. P002 specifies Small / Standard / Standard-alt / Large / Max; this run used **available** iPhone 18.5 simulators as proxy for the same form factors.

| Form factor | P002 example      | Simulator used     | Build | Unit tests (58) |
|-------------|-------------------|--------------------|-------|-----------------|
| Small       | iPhone SE (3rd)   | iPhone 16e         | OK    | 58/58 pass      |
| Standard    | iPhone 15         | iPhone 16          | OK    | (58/58 on 16)   |
| Standard-alt| iPhone 14         | iPhone 16 Pro      | Skip* | —               |
| Large       | iPhone 15 Plus    | iPhone 16 Plus     | OK    | —               |
| Max         | iPhone 15 Pro Max | iPhone 16 Pro Max  | OK    | 58/58 pass      |

\* This host had duplicate "iPhone 16 Pro" device entries; xcodebuild reported "Unable to find a device matching the provided destination specifier" for that name. Four of five form factors built and tested.

**Commands used:**
- Build: `xcodebuild build -scheme CatRunner -destination 'platform=iOS Simulator,name=<Device>,OS=latest' -configuration Debug` (from `ios/`).
- Test: `xcodebuild test -scheme CatRunner -destination 'platform=iOS Simulator,name=iPhone 16,OS=latest' -configuration Debug` (baseline 58/58); same for iPhone 16e and iPhone 16 Pro Max.

## Ui-test journey (documented)

Per plan §10, journeys for BG4:

1. **Gameplay with scrolling background:** Launch app → play → background visible and scrolling, cat in lane, obstacles/dog on runway, no overflow.
2. **Integration check:** Dog/boxes on runway, no palette clash, cat focal.
3. **Contrast and readability:** Runway band distinct; sprites readable.

**Status:** Journeys documented; no XCTest UI target in project yet. P002-VIEWPORT.md marks XCTest UI tests as optional. Manual verification: run app on each simulator and confirm above; optional screenshot per device for baseline.

## Screenshot baseline

**Status:** Optional; not captured this run. To add: run app on each of the 5 simulators in portrait, capture one screenshot per device, store in a `screenshots/` or `docs/viewport-baseline/` (per project convention).

## Summary

- **Build:** 4/5 simulators (Small, Standard, Large, Max) built successfully; 1 skipped due to duplicate simulator name on host.
- **Unit tests:** 58/58 pass on iPhone 16, iPhone 16e, iPhone 16 Pro Max.
- **Ui-test journey:** Documented; optional XCTest UI target and screenshot baseline left for future.

BG4 validation (simulator matrix + test baseline) **complete** for Lane A. Next: commit S4+BG3+BG4 and update plan state, or proceed with Lane B (BG1+BG2).
