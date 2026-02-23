# P002 Viewport & Alignment (ui-test criteria and 5-iPhone matrix)

Reference: [Agents/ui-test.md](../Agents/ui-test.md). Design size: **393×852 pt** portrait; `scaleMode = .aspectFit` in GameViewController.

## Alignment and layout criteria (vertical runner)

- **Player in view:** Avatar (player node) must be fully visible within the safe area; player at `laneY = size.height * 0.28` (lower third).
- **Lanes visible:** All 5 lane lines drawn from `laneY` to top of screen (`size.height`); no clipping of lane lines.
- **Obstacles/enemies in correct vertical band:** Segment sprites (obstacles, power-ups, enemies) move from top toward player (positive y → lower y); positions `y = laneY + (timeOffset - segmentTime) * SegmentScrollSpeed`; no horizontal scroll.
- **Aspect fit:** On all devices the 393×852 design size is scaled to fit (letterboxing if aspect differs); no crop of gameplay area.

## 5-iPhone viewport matrix (last 5 Apple phone form factors)

Resolve exact simulator names from Xcode destinations. Representative viewports (portrait) for verification:

| Form factor | Example device | Viewport (portrait) | Simulator / Playwright key |
|-------------|----------------|---------------------|----------------------------|
| Small       | iPhone SE (3rd gen) | 375 × 667        | iPhone SE (3rd generation) |
| Standard    | iPhone 14 / 15     | 393 × 852        | iPhone 15                  |
| Standard-alt| iPhone 14           | 390 × 844        | iPhone 14                   |
| Large       | iPhone 15 Plus      | 430 × 932        | iPhone 15 Plus             |
| Max         | iPhone 15 Pro Max   | 430 × 932        | iPhone 15 Pro Max          |

Design size 393×852 scales with aspectFit: on narrower (e.g. SE 375pt) or wider (e.g. Pro Max 430pt) the scene is letterboxed; player and lanes remain visible.

## Verification

- **Simulator matrix:** Run app on each of the 5 simulators above; confirm player visible, lanes visible, obstacles moving top→bottom.
- **XCTest UI tests (optional):** Add UI test target that launches app, captures snapshot or checks layout; run against same 5 destinations.
- **Screenshot:** One screenshot per device in portrait to document layout.

This file is the P002 viewport deliverable for native iOS (Lane A). ui-test agent may refine criteria and add Playwright viewport keys if web version exists.

## P002 completion hand-off (Lane A)

After vertical runner, avatar/enemy visibility, and viewport doc are done: **invoke Blaster** for plan-validation pipeline, then **invoke Planner** to update Master-Plan and next hand-offs. Reference: [Agents/blaster.md](../Agents/blaster.md), [Agents/planner.md](../Agents/planner.md).
