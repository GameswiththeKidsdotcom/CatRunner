**Status:** Done. Mockups generated and stored in `assets/ui/`; `implementation-spec.md` added; `config/default/assets.json` updated with `ui.scorePanel`.

**Next hand off (cut & paste) — Lane B:** Create pixel-art sprites for character, obstacles, dogs, backgrounds, and powerups per [sprites-ui-assets.plan.md](sprites-ui-assets.plan.md) §2–§3 using the ui-designer workflow and canva-ui-design skill. Match the style of existing `assets/ui/` mockups (pixel art). Store images in `assets/` (character/, obstacles/, dogs/, backgrounds/, powerups/); update `config/default/assets.json` only if adding new asset keys. Lane B may edit `config/` and `assets/` only; no `ios/` or `src/` changes.

---

# UI mockups via ui-designer — plan

## Goal

Create game UI mockups using [Agents/ui-designer.md](../../Agents/ui-designer.md) and the **canva-ui-design** skill, then store both generated images and implementation specs in the repo under `assets/` (Lane B: config/ and assets/ only; no ios/ or src/).

## Scope: what counts as "mockups"

- **In scope:** In-game UI screens/panels (Revive dialog, Game over screen, optional score panel art), plus optional brand (app icon source, admin logo/favicon). These align with [sprites-ui-assets.plan.md](sprites-ui-assets.plan.md) §3 (in-game HUD, app icon/brand).
- **Out of scope for this plan:** Sprite art (character, dogs, obstacles, backgrounds, powerups). Those can be a follow-up; ui-designer can be used for style consistency if desired.

## Where to store in "game files"

| Deliverable | Location | Notes |
|-------------|----------|--------|
| Mockup images | [assets/ui/](../../assets/ui/) | Replace or add to existing placeholders: `revivePanel.png`, `gameOver.png`; optional `scorePanel.png`, `appIcon_source.png`, `logo.png` |
| Implementation specs | [assets/ui/implementation-spec.md](../../assets/ui/implementation-spec.md) (new) | Single doc: layout, typography, colors, spacing, SKNode hierarchy hints per ui-designer "Implementation Spec Format" |

Paths already referenced in [config/default/assets.json](../../config/default/assets.json) (`ui.revivePanel`, `ui.gameOver`) stay as-is; new assets (e.g. score panel, app icon source) can be added to `assets.json` or documented in the spec only until C8 consumes them.

## Ui-designer workflow to follow

1. **Clarify** (if needed): Screen type (mobile game, portrait), audience (casual players), palette, aspect ratio (9:16 for full-screen overlays per plan §3.1). **Style is fixed: pixel art.** Ask 2–4 questions before generating only when other details are missing.
2. **Image prompt structure** (per ui-designer): Subject → Layout (Z-pattern for overlays) → **Style: pixel art** → Typography (pixel font / blocky) → Colors → Technical (9:16, dimensions). **Mockups should be as close to final as possible: include actual titles and button labels in the image** (e.g. "Game Over", "Play again", "Revive?") so the PNG is the final look.
3. **Generate**: Use GenerateImage for each mockup; apply canva-ui-design skill (hierarchy, rule of thirds, contrast, white space).
4. **Persist to repo**: Generated images are written by the tool to a Cursor asset path; **copy or save each image into the workspace** at the correct path under `assets/ui/` (e.g. `assets/ui/revivePanel.png`) so the game and config can load them. Document the chosen approach in the plan or in a one-line comment in [assets/README.md](../../assets/README.md).
5. **Implementation spec**: After all images are generated, write [assets/ui/implementation-spec.md](../../assets/ui/implementation-spec.md) with layout, typography, colors, spacing, and component placement (and, if useful, SKNode hierarchy notes for C8).

## Suggested mockup set and order

1. **Game over screen** — Full-screen overlay mockup (9:16), **pixel art**. Include final text in image: title (e.g. Game Over), score area, Play again button. Z-pattern; focal point on CTA. Save as `assets/ui/gameOver.png`.
2. **Revive dialog** — Panel/overlay mockup (9:16 or letterboxed), **pixel art**. Include final text: Revive CTA (e.g. Revive? / Watch ad to revive), optional secondary "Quit" or "No thanks". Save as `assets/ui/revivePanel.png`.
3. **Optional: Score panel** — Small HUD strip or score panel art (if not text-only). Dimensions suitable for top or corner; document in spec. Save as `assets/ui/scorePanel.png` and add to assets.json if the game will reference it.
4. **Optional: App icon source** — 1024×1024 PNG, no transparency, for handoff to ios/ by another lane. Save as `assets/ui/appIcon_source.png` (Lane B does not edit ios/).
5. **Optional: Admin logo/favicon** — For Next.js admin; size per plan (e.g. 24–32 pt or favicon). Save as `assets/ui/logo.png` or similar.

## Technical details

- **Aspect ratio:** 9:16 for full-screen overlays (revive, game over); optional score panel can be a narrow strip (e.g. 9:1 or similar).
- **Style:** **Pixel art** throughout. Mockups are **as close to final as possible**: include actual titles and button labels in the image so C8 can use the PNGs as final (or near-final) assets; minimal or no text added in code.
- **Rollback:** Keep current 1×1 placeholders as backup or replace in place; implementation-spec.md is additive. If a mockup is wrong, regenerate and overwrite the PNG; revert spec doc via git if needed.
- **Validation:** Confirm each PNG exists under `assets/ui/` and is a valid image; optionally open in viewer. Spec doc should be readable and reference the same filenames.

## Risks and confidence

- **Risk:** GenerateImage output path may differ by environment; the "copy into workspace" step must be robust (e.g. glob for recently created PNGs under `.cursor` or use a documented path).
- **Confidence:** High that ui-designer workflow + canva-ui-design produce usable mockups; medium that the exact copy step is portable (document and test once).

## Summary

- Use ui-designer (and canva-ui-design) to create Revive and Game over mockups, then optional score panel, app icon source, and admin logo.
- Save all generated images into `assets/ui/` at the paths above, with a defined copy/save step from tool output to workspace.
- Add `assets/ui/implementation-spec.md` with layout, typography, colors, spacing, and components.
- No changes to ios/ or src/; optional update to [config/default/assets.json](../../config/default/assets.json) only if new assets (e.g. scorePanel) are added.
