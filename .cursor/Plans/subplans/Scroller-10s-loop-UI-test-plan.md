# Blaster Step 2 — UI/UX & Viewport Test Plan

**Initiative:** Scroller 10s Loop and Avatar-Proportional Sizing  
**Reference:** [Scroller-10s-loop-and-sizing.plan.md](Scroller-10s-loop-and-sizing.plan.md), [ios/P002-VIEWPORT.md](../ios/P002-VIEWPORT.md), [Agents/ui-test.md](../Agents/ui-test.md)

---

## 1. E2E / UX checks (simulator or automated)

- **Segment duration:** One segment runs at least 10 seconds before wrap; confirm via timer or debug label (e.g. segment elapsed time).
- **Seamless loop:** After segment end, the **same** segment repeats (same obstacle/enemy positions and timing); no visible jump or new layout; no `addSegmentCompleted` on restart (score does not increment on loop).
- **Avatar-proportional sprites:** Obstacles and dog (enemy) sprites have max dimension 44 pt; scale formula `min(44 / max(w,h), 1.0)`; no upscaling; aspect ratio preserved.
- **Visual hierarchy:** Avatar remains focal; obstacles/dog read as secondary and consistently sized relative to 44×44 pt avatar.

*Example assertion (concept):* `XCTAssertEqual(playerNode.size.width, 44); XCTAssertLessThanOrEqual(obstacleNode.size.width, 44); XCTAssertLessThanOrEqual(obstacleNode.size.height, 44);`

---

## 2. Viewport (5-iPhone matrix, design size)

- **No change from P002:** Design size remains **393×852 pt** portrait; `scaleMode = .aspectFit` in GameViewController.
- **5-iPhone matrix:** Same as P002 — Small (SE 3rd gen 375×667), Standard (iPhone 15 393×852), Standard-alt (iPhone 14 390×844), Large (15 Plus 430×932), Max (15 Pro Max 430×932). Run on each: player visible, lanes visible, obstacles in vertical band; letterboxing on non-393-width devices.
- **New check for Step 2:** On all 5 viewports, confirm 10s segment and loop behavior and 44pt sprite scaling still hold (no layout regression from sizing changes).

---

## 3. Layout / alignment (new or reinforced assertions)

- **Player in view:** Avatar fully visible in safe area; player at `laneY = size.height * 0.28` (unchanged from P002).
- **Lanes visible:** All 5 lane lines from `laneY` to top; no clipping.
- **Obstacles in vertical band:** Segment sprites (obstacles, power-ups, dog) move top→bottom in the scroll band; positions consistent with `y = laneY + (timeOffset - segmentTime) * SegmentScrollSpeed`; no horizontal scroll.
- **New for Step 2:** Obstacles and dog stay within the same vertical band after scaling (44pt max); no overflow or clipping of scaled sprites at lane edges; alignment with lanes preserved after `refreshSegmentSprites()` scaling.

---

## 4. Output and hand-off

- **Deliverable:** This one-page test plan (bullet list only; one example assertion in §1).
- **Parent:** May append or link this in the main Scroller-10s-loop plan or a consolidated test-plan doc; run E2E/viewport checks per matrix above.
