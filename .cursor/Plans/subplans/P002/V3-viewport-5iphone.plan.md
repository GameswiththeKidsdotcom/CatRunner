# P002 — Chunk V3: Viewport and 5-iPhone matrix (ui-test)

**Parent:** [P002-vertical-runner-viewport.plan.md](P002-vertical-runner-viewport.plan.md)

## Goal

Alignment and layout criteria for the vertical runner; viewport matrix for last 5 Apple phone form factors; design size 393×852 scales correctly (aspect fit); verification documented.

## Deliverables

1. **Alignment criteria:** Player in view, lanes visible, obstacles/enemies in correct vertical band, aspect fit (see ios/P002-VIEWPORT.md).
2. **5-iPhone matrix:** Small (iPhone SE 3rd), Standard (iPhone 15), Standard-alt (iPhone 14), Large (15 Plus), Max (15 Pro Max). Build + unit tests on simulators.
3. **Verification:** Simulator matrix and/or XCTest UI tests; optional screenshot per device.

**Reference:** Agents/ui-test.md; ios/P002-VIEWPORT.md; ios/P002-viewport-validation-2026-02-23.md.

## Validation

P002-viewport-validation-2026-02-23.md: alignment criteria verified; 5/5 simulators build OK; 58/58 unit tests pass on iPhone SE (3rd gen) and iPhone 15 Pro Max.

## Rollback

No code change in this chunk (documentation and test matrix). If viewport criteria change, update P002-VIEWPORT and re-run validation.

## Confidence (per-chunk fidelity)

- **Confidence (root cause):** 95% — Root cause: viewport consistency across devices; criteria and matrix defined and verified.
- **Confidence (solution path):** 95% — Solution path (P002-VIEWPORT + validation doc + 5-iPhone matrix) complete; ui-test scope captured.
- **Note:** ui-test deliverable complete; test coverage and viewport matrix documented. No new mockup; layout criteria only.
