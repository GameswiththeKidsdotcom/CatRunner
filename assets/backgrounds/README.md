# Backgrounds

Background layers per **config/default/assets.json**: `backgrounds.sky`, `backgrounds.ground` → `assets/backgrounds/sky.png`, `ground.png`.

- **Layers:** Sky, ground (optional mid); tileable or viewport-wide.
- **Aspect:** e.g. 9:16 for portrait.
- **Spec:** [sprites-ui-assets.plan.md](../../.cursor/Plans/subplans/P001/sprites-ui-assets.plan.md) §2.4.
- **Current:** `sky.png` and `ground.png` are many-buildings tileable strips in **top-down (bird's-eye) POV** — rooftop planes and runway band for vertical scrolling — per [Many-buildings-bg.plan.md](../../.cursor/Plans/zz-archives/zz-Many-buildings-bg/Many-buildings-bg.plan.md) and [CAT-WORLD-VISION.md](../CAT-WORLD-VISION.md). Soft 2D, tileable vertically; produced via ui-designer + canva-ui-design (BG1+BG2). Single-tile height ~800–1000 px at @2x for vertical tiling; optional 3× length (e.g. 768×4128 px) for longer strips.
