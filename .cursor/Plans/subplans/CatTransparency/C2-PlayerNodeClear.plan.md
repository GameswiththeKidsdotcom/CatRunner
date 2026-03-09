# C2 — PlayerNode use clear color when textures present

**Next hand off (cut & paste):** Done. C2 executed 2026-03-09; 77 CatRunnerTests pass.

---

**Chunk of:** [CatTransparency-TransparencyAndBackgroundFix.plan.md](CatTransparency-TransparencyAndBackgroundFix.plan.md)

---

## Outcome

- PlayerNode with textures uses `color: .clear` (no tint on transparent areas)
- PlayerNode with nil texture (tests) keeps `color: .systemTeal` (placeholder)

---

## Steps

1. Edit [ios/CatRunner/Game/PlayerNode.swift](ios/CatRunner/Game/PlayerNode.swift) line 84.
2. Change: `super.init(texture: runTexture, color: .systemTeal, size: PlayerNode.defaultSize)`  
   To: `super.init(texture: runTexture, color: runTexture != nil ? .clear : .systemTeal, size: PlayerNode.defaultSize)`
3. Run `xcodebuild test -scheme CatRunner -only-testing:CatRunnerTests`; verify pass.

---

## Detailed Design

**Rationale:** SKSpriteNode blends texture with `color`. Obstacles use `color: .clear` (GameScene line 539). Player used `.systemTeal`; that can tint transparent areas or cause artifacts. When we have textures, use `.clear` for consistency.

**Edge case:** `runTexture` nil when asset load fails. GameScene passes `assetConfig?.texture(forKey: "character.run")`; if nil, we want teal placeholder. The change preserves that.

---

## Confidence

| | Confidence (root cause) | Confidence (solution path) |
|---|-------------------------|----------------------------|
| C2 | 95% | 95% |

**Note:** One-line change; clear rollback; tests use PlayerNode() (nil texture) and still get .systemTeal.

---

## Rollback

Revert the PlayerNode.swift line; `git checkout -- ios/CatRunner/Game/PlayerNode.swift`
