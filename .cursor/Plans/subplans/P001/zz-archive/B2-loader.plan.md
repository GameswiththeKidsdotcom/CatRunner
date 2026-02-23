# B2 — Asset loader (read assets.json, resolve paths)

**Status:** Done. Detailed Design and Best Routes added; AssetConfig implemented; assets.json loaded from bundle; character.run resolves to SKTexture; GameScene holds assetConfig for B3. Next: [B3-player-texture.plan.md](B3-player-texture.plan.md).

---

## Goal

iOS code loads `assets.json` from the bundle and exposes a simple API to get a texture (or image) for a given key (e.g. `character.run`, `obstacles.passable`). B1 must be complete so the file exists in the bundle.

## Steps

1. Define a struct (e.g. `AssetConfig`) that mirrors the keys in [config/default/assets.json](../../../config/default/assets.json): `character.run`, `obstacles.passable` / `instantFail` / `slowdown`, `enemies.dog`, `backgrounds.sky` / `ground`, `powerups.speedBoost` / `shield`, `ui.revivePanel` / `gameOver` / `scorePanel`. Decode from JSON (Codable).
2. Load from bundle: e.g. `Bundle.main.url(forResource: "assets", withExtension: "json", subdirectory: "config/default")` or equivalent so the file is found. If B1 placed files under a different structure, use that (e.g. `forResource: "assets", withExtension: "json"` in bundle root).
3. Add a method that, given a path string from config (e.g. `assets/character/cat_run.png`), returns a `SKTexture` or `UIImage` by resolving the path relative to the bundle. For example: split path into directory and filename, then `Bundle.main.url(forResource: filename, withExtension: nil, subdirectory: directory)` or use `Bundle.main.url(forResource:path, withExtension:nil)`. Create `SKTexture(image: UIImage(contentsOfFile: url.path))` or similar. Return nil when the file is missing.
4. Call this loader once at startup (e.g. from GameScene or a shared config holder) and hold the result so GameScene and PlayerNode (B3) and obstacle/power-up rendering (B4) can use it.

## Paths

- **New/edited:** e.g. `ios/CatRunner/Engine/AssetConfig.swift` or under `ios/CatRunner/Game/`. Loader used from GameScene.

## Detailed Design

- **SPEC:** Load `assets.json` from app bundle (path per B1: `config/default/assets.json`). Decode to a struct mirroring keys: `character.run`, `obstacles.passable` / `instantFail` / `slowdown`, `enemies.dog`, `backgrounds.sky` / `ground`, `powerups.speedBoost` / `shield`, `ui.revivePanel` / `gameOver` / `scorePanel`. Expose API: given a logical key (e.g. `character.run`) or a path string, return `SKTexture?` by resolving path relative to `Bundle.main`; return nil when file is missing. Single load at startup; holder usable by GameScene, PlayerNode (B3), and obstacle/power-up rendering (B4).
- **Dependencies (B1):** B1 must be complete. Bundle layout: `CatRunner.app/config/default/assets.json`, `CatRunner.app/assets/character/cat_run.png`, etc. Loader assumes these relative paths; no fallback if B1 not run.
- **Integration points:**
  - **GameScene:** Call loader once in `didMove(to:)` (or alongside `loadEngineConfig()`); hold result in a property or shared singleton so `addPlayer()` (B3) can pass texture to PlayerNode.
  - **Bundle paths:** `Bundle.main.url(forResource: "assets", withExtension: "json", subdirectory: "config/default")` for assets.json. For a path string like `assets/character/cat_run.png`: split into directory `assets/character` and filename `cat_run.png`, then `Bundle.main.url(forResource: "cat_run", withExtension: "png", subdirectory: "assets/character")`; build `SKTexture(image: UIImage(contentsOfFile: url.path))`.
- **Risks:** assets.json or asset file missing in bundle (e.g. B1 copy failed) → loader returns nil; callers must handle nil (B3: keep current teal placeholder). Schema change in assets.json (new keys) → extend Codable struct and API if needed.
- **Rollback:** Remove `AssetConfig`/loader type and all call sites; no other code depends on it until B3/B4. Revert ios/ changes only.

## Best Routes Ahead of Building

1. **Add `AssetConfig.swift`** under `ios/CatRunner/Engine/`: Codable struct(s) matching assets.json (character, obstacles, enemies, backgrounds, powerups, ui; optional appIcon). Static `load(fromBundle:subdirectory:)` that returns `AssetConfig?`; internal method `texture(for path: String) -> SKTexture?` using path split and `Bundle.main.url(forResource:withExtension:subdirectory:)` + `UIImage(contentsOfFile:)` + `SKTexture(image:)`.
2. **Expose by key:** Method `texture(forKey key: String)` or `characterRunTexture` etc. that looks up path from config and calls `texture(for:)`. Prefer one generic `texture(forKey:)` with keys like `"character.run"` (dot notation in JSON decoded as nested struct).
3. **Wire once at startup:** From GameScene, after `loadEngineConfig()`, call `AssetConfig.load(...)` and store in a property or a shared singleton (e.g. `AssetLoader.shared`) so B3 can ask for `character.run` texture without re-reading JSON.
4. **Validation:** Unit test in CatRunnerTests: load assets.json from test bundle or main bundle, resolve `character.run`, assert non-nil texture when file exists. Alternatively: launch app and log in GameScene; confirm non-nil when `assets/character/cat_run.png` is in bundle.

## Validation

- Unit test or launch and log: load assets.json and resolve `character.run`; confirm non-nil texture when the file exists in the bundle. If asset is missing, confirm nil or fallback and no crash.

## Rollback

- Remove AssetConfig and loader; remove any call sites. No other code depends on it until B3/B4.

## Confidence

- **Confidence (root cause):** N/A.
- **Confidence (solution path):** High.
