# CatWorld A1 — Character (cat_run.png)

**Next hand off:** Same as [CatWorld-assets.plan.md](CatWorld-assets.plan.md) until A1 is done; then Master-Plan Lane B points to A2.

## Goal

Replace placeholder character sprite with cat-world style run pose. Single image; used by PlayerNode.

## Steps

1. Build image prompt per ui-designer: Subject = running cat sprite; Layout = centered, single character; Style = soft cozy 2D, rounded, storybook; Colors = warm orange/cream cat, transparent or simple dark BG; Technical = ~132px square (44pt @3x), PNG, transparency.
2. Generate via GenerateImage; save to `assets/character/cat_run.png` (overwrite placeholder).
3. Optionally add one line in `assets/character/README.md`: asset is cat-world style per CAT-WORLD-VISION.md.

## Path

- **Save:** `assets/character/cat_run.png`
- **Config:** `config/default/assets.json` → `character.run` (no change).

## Validation

- File exists at path; opens in viewer; cat in run pose; soft rounded style; transparent background.

## Rollback

- `git checkout -- assets/character/cat_run.png` (restore previous).

## Confidence

- **Confidence (root cause):** N/A
- **Confidence (solution path):** High
