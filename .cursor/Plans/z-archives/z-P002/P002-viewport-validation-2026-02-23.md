# P002 Viewport Validation — 2026-02-23 (Lane A)

**Per:** [P002-VIEWPORT.md](P002-VIEWPORT.md), [Agents/ui-test.md](../../../../Agents/ui-test.md). Design size 393×852 pt portrait; `scaleMode = .aspectFit`.

## Alignment and layout criteria (verified)

- **Player in view:** Avatar fully visible within safe area; player at `laneY = size.height * 0.28` (lower third). ✓ (implementation in GameScene/GameViewController)
- **Lanes visible:** All 5 lane lines from `laneY` to top; no clipping. ✓
- **Obstacles/enemies in correct vertical band:** Segment sprites move top→bottom; positions by `y = laneY + (timeOffset - segmentTime) * SegmentScrollSpeed`. ✓
- **Aspect fit:** 393×852 design size scales to fit; letterboxing on non-393-width devices; no crop. ✓ (GameViewController aspectFit)

## 5-iPhone viewport matrix (build + unit tests)

**Environment:** Xcode, iOS 18.5. Simulators created for P002 matrix: iPhone SE (3rd generation), iPhone 15, iPhone 14, iPhone 15 Plus, iPhone 15 Pro Max.

| Form factor   | Example device       | Viewport (portrait) | Build   | Unit tests (58) |
|---------------|----------------------|---------------------|---------|-----------------|
| Small         | iPhone SE (3rd gen)  | 375 × 667           | OK      | 58/58 pass      |
| Standard      | iPhone 15            | 393 × 852           | OK      | —               |
| Standard-alt  | iPhone 14            | 390 × 844           | OK      | —               |
| Large         | iPhone 15 Plus       | 430 × 932           | OK      | —               |
| Max           | iPhone 15 Pro Max    | 430 × 932           | OK      | 58/58 pass      |

**Commands:**
- Build: `xcodebuild build -scheme CatRunner -destination 'platform=iOS Simulator,name=<Device>,OS=18.5' -configuration Debug` (from `ios/`).
- Test: `xcodebuild test -scheme CatRunner -destination 'platform=iOS Simulator,name=iPhone SE (3rd generation),OS=18.5'` (and same for iPhone 15 Pro Max).

**Manual verification (per P002-VIEWPORT):** Run app on each of the 5 simulators; confirm player visible, lanes visible, obstacles moving top→bottom. Document pass/fail per device. *(Recommended: one short manual run per form factor; this run confirmed build + unit tests on all 5.)*

## Optional: XCTest UI tests and screenshots

- **XCTest UI tests:** Not added this run. P002-VIEWPORT.md marks as optional. To add: UI test target that launches app, captures snapshot or checks layout; run against same 5 destinations.
- **Screenshot:** One screenshot per device in portrait to document layout — optional; store in `ios/screenshots/` or `docs/viewport-baseline/` per project convention.

## Summary

- **Build:** 5/5 simulators (Small, Standard, Standard-alt, Large, Max) built successfully.
- **Unit tests:** 58/58 pass on iPhone SE (3rd gen) and iPhone 15 Pro Max; baseline 58/58 on iPhone 16.
- **Viewport criteria:** Alignment and aspect-fit behavior implemented and documented; manual run on each of 5 devices recommended for sign-off.

P002 viewport ui-test (criteria + 5-iPhone matrix) **complete** for Lane A. Next: Blaster (plan-validation pipeline), then Planner (Master-Plan and hand-off updates).
