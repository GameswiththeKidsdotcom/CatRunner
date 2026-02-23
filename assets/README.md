# Asset directories

Paths are defined in **config/default/assets.json** (path map source of truth: `.cursor/Plans/subplans/P001/sprites-ui-assets.plan.md` §6).

| Directory        | Purpose                                      |
|------------------|----------------------------------------------|
| character/       | Player cat (e.g. cat_run.png)                |
| obstacles/       | passable, instantFail, slowdown sprites      |
| dogs/            | Enemy dog sprite(s)                          |
| backgrounds/     | sky, ground (and optional mid) layers        |
| powerups/        | speedBoost, shield in-lane sprites           |
| ui/              | HUD, revive panel, game over screen assets; pixel-art mockups + implementation-spec.md (ui-mockups.plan) |

App icon lives in `ios/CatRunner/Assets.xcassets/AppIcon.appiconset/` (see plan; Lane B does not edit ios/).

**Current state:** Pixel-art sprites in place for character (cat_run), obstacles (passable, instantFail, slowdown), dogs (dog), backgrounds (sky, ground), powerups (speedBoost, shield), and ui/ (mockups + implementation-spec). All paths in `assets.json`; style per sprites-ui-assets.plan.md and ui-mockups (Lane B, ui-designer workflow).
