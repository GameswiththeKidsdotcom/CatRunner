# Cat World — Visual Vision

Single reference for the CatRunner “cat world” look. Use this when creating or replacing assets so the game feels cohesive.

**Style:** Soft, cozy 2D — rounded shapes, warm accents, storybook feel.  
**Setting:** City rooftops at night — skyline, ledges, neons.  
**Mood:** Energetic and punchy — cozy cat in a vibrant night city.

**Hero reference image:** [assets/reference/cat-world-hero-mockup.png](reference/cat-world-hero-mockup.png) — use this as the style reference for all in-game art.

---

## 1. World pillar

- **Where:** Rooftops at night. Distant city skyline with neon signs; 5 lanes read as roof ledges or platforms.
- **Lighting:** Night blues and purples; neon accents (warm pink/amber, cool cyan/blue). The cat stays warm (orange/cream) so it reads clearly.
- **Obstacles:** Urban rooftop props — vents, AC units, antennas, planters, loose tiles — not generic blocks. Same soft, rounded 2D style.

---

## 2. Character (player cat)

- **Look:** One hero cat — soft silhouette, rounded, readable at ~44pt. Run, jump, slide poses; cozy but with enough energy to feel like they’re moving.
- **Path:** `assets/character/`. Reference: hero mockup cat; keep proportions and line weight consistent.

---

## 3. Obstacles

- **passable:** Small crates, boxes, or harmless rooftop clutter (jump-over).
- **instantFail:** Vents, gaps, or clear danger; same soft 2D style.
- **slowdown:** Puddles, wet patches, or sticky spots.
- **Path:** `assets/obstacles/`. All rooftop-themed, rounded forms.

---

## 4. Enemies (dogs)

- Stylized city dogs (e.g. strays or guard dogs); same soft 2D style; slightly threatening but not scary. Path: `assets/dogs/`.

---

## 5. Backgrounds

- **Layers:** Far skyline (silhouette + neon signs), mid (other roofs, windows), foreground ledges. Tileable or viewport-wide; aspect e.g. 9:16.
- **Assets:** `sky.png` and `ground.png` — many-buildings tileable vertical strips in **top-down (bird's-eye) POV**; 3× length (768×4128 px); ground = runway band for lanes. See `assets/backgrounds/README.md`.
- **Palette:** Night blues/purples with neon accents. Path: `assets/backgrounds/`.

---

## 6. Power-ups

- **speedBoost:** E.g. coffee cup or lightning bolt; soft glow; readable at small size.
- **shield:** E.g. bubble or umbrella; same treatment.
- Path: `assets/powerups/`.

---

## 7. UI (HUD, revive, game over)

- Rounded panels; warm neutrals + one accent (e.g. neon pink or amber). Score, revive, game over copy can be world-aware (e.g. “Run again”).
- Typography: max 2 families; headline 24–32px, subhead 16–20px, body 14–16px; rounded or friendly weight.
- Path: `assets/ui/`.

---

## 8. App icon

- Cat silhouette on a rooftop at night with a small neon glow. 1024×1024, no transparency. Recognizable at small size. Path: `ios/CatRunner/Assets.xcassets/AppIcon.appiconset/`.

---

## 9. Implementation spec (for devs)

| Item | Guidance |
|------|----------|
| **Layout** | Lanes = horizontal bands (roof ledges). HUD score top-center or top-left. Revive/game over = centered overlays (Z-pattern). |
| **Typography** | 3 levels: headline 24–32px, subhead 16–20px, body 14–16px. Rounded or friendly weight; max 2 font families. |
| **Colors** | CSS/design tokens: `--night-bg`, `--neon-pink`, `--neon-cyan`, `--cat-warm`, `--panel-bg` (semi-transparent dark). |
| **Spacing** | Comfortable padding; HUD not overlapping lane area; panels border-radius 12–16px. |
| **Assets** | All art (character, obstacles, dogs, backgrounds, power-ups, UI panels, icon) should match the hero mockup in style. |

---

*Created from ui-designer flow: soft/cozy 2D, rooftops at night, energetic mood. Hero mockup: `assets/reference/cat-world-hero-mockup.png`.*
