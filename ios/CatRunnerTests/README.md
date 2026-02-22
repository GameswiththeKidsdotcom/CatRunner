# CatRunnerTests

Unit tests for C4 obstacle placement and C5 path guarantee.

**To run these tests:** In Xcode, add a new **Unit Testing Bundle** target (e.g. `CatRunnerTests`), add `ObstaclePlacementTests.swift` and `PathGuaranteeTests.swift` to it, link the app target as the test host, and add `GameplayKit.framework` and `XCTest.framework` to the test target.

Tests cover:
- **C4:** Lane index valid (0–4), span ≤ lanes and startLane + span ≤ lane count, span ≤ 5, cluster config.
- **C5:** Path guarantee (blocked lanes = instantFail or full-span; ≥1 viable lane per segment), N-seed viability, same-seed determinism regression.
