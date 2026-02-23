# P001-CatWorld-Assets — Replace placeholders with cat-world art

**Next hand off (cut & paste) — Lane B:** Execute **A4** (backgrounds: sky.png, ground.png). See [CatWorld-A4-backgrounds.plan.md](CatWorld-A4-backgrounds.plan.md). When A4–A7 remain, continue in order. App icon source: `assets/reference/appIcon_catworld_1024.png` — copy to `ios/CatRunner/Assets.xcassets/AppIcon.appiconset/` (Lane A or user).

---

## Scope

Replace all placeholder/pixel-art assets with cat-world–themed images (soft cozy 2D, rooftops at night, neon accents). Lane B only: `config/` and `assets/`; ui-designer for image generation. No `ios/` or `src/` code changes; paths stay in [config/default/assets.json](../../../config/default/assets.json).

## Style anchor

- **Reference:** [assets/reference/cat-world-hero-mockup.png](../../../assets/reference/cat-world-hero-mockup.png), [assets/CAT-WORLD-VISION.md](../../../assets/CAT-WORLD-VISION.md).
- **Look:** Soft cozy 2D; rounded shapes; city rooftops at night; night blues/purples + neon pink/amber/cyan; warm orange/cream cat; no pixel art.

## Phases (sub-plans)

| Phase | Sub-plan | Deliverable | Path(s) |
|-------|----------|-------------|---------|
| A1 | [CatWorld-A1-character.plan.md](CatWorld-A1-character.plan.md) | cat_run.png | assets/character/cat_run.png |
| A2 | [CatWorld-A2-obstacles.plan.md](CatWorld-A2-obstacles.plan.md) | passable, instantFail, slowdown | assets/obstacles/*.png |
| A3 | [CatWorld-A3-enemies.plan.md](CatWorld-A3-enemies.plan.md) | dog.png | assets/dogs/dog.png |
| A4 | [CatWorld-A4-backgrounds.plan.md](CatWorld-A4-backgrounds.plan.md) | sky.png, ground.png | assets/backgrounds/*.png |
| A5 | [CatWorld-A5-powerups.plan.md](CatWorld-A5-powerups.plan.md) | speedBoost.png, shield.png | assets/powerups/*.png |
| A6 | [CatWorld-A6-ui.plan.md](CatWorld-A6-ui.plan.md) | scorePanel, gameOver, revivePanel | assets/ui/*.png |
| A7 | [CatWorld-A7-appicon.plan.md](CatWorld-A7-appicon.plan.md) | App icon 1024×1024 | assets/reference/appIcon_catworld_1024.png (copy to ios/ by Lane A or user) |

## Validation and rollback

- **Validation:** Each phase verifies file(s) exist and match theme (visual check or README note).
- **Rollback:** Restore previous asset files from git; paths unchanged.

## Confidence

- **Confidence (root cause):** N/A (design/asset plan).
- **Confidence (solution path):** High (paths and style fixed; ui-designer workflow defined).
