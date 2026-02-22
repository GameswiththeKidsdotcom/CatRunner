# C1 — Xcode Bootstrap

**Next hand off:** Same as Master-Plan Lane A — implement C1; then update hand off to C2.

---

## Goal

Create Xcode project scaffold: iOS/SpriteKit app at `ios/CatRunner` with 5-lane scene and player node at lane 2.

## Steps

1. Create `ios/` at repo root.
2. Create new iOS App project in Xcode: Game template, SpriteKit, Swift.
3. Name: CatRunner; bundle ID: com.catrunner.game.
4. Add `GameScene`: 5 horizontal lanes (0–4), lane 2 = center.
5. Add `PlayerNode` (SKSpriteNode) at lane 2 y-position.
6. Map lane index → x position (lanes evenly spaced).
7. Ensure `Info.plist` allows portrait or landscape per spec.
8. Add `Engine/` and `Game/` folders under `ios/CatRunner/`; add `Assets.xcassets` if not present.

## Validation

- `xcodebuild -scheme CatRunner -destination 'generic/platform=iOS Simulator' build` succeeds.
- App runs in simulator; 5 lanes visible; player centered.

## Rollback

- Remove `ios/`; re-run from clean state.

## Confidence

- **Confidence (root cause):** 95%
- **Confidence (solution path):** 95%
