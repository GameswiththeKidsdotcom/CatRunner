# UI mockups — implementation spec

Generated per [ui-mockups.plan.md](../../.cursor/Plans/subplans/P001/ui-mockups.plan.md). Pixel art style; final text is baked into images where specified. Use these assets in C8 (difficulty, scoring, revive) and C9 (admin) as needed.

---

## Asset inventory

| File | Purpose | Aspect / size | Config key (if any) |
|------|---------|---------------|---------------------|
| `gameOver.png` | Full-screen game over overlay | 9:16 | `ui.gameOver` |
| `revivePanel.png` | Revive dialog (watch ad / no thanks) | 9:16 or letterboxed | `ui.revivePanel` |
| `scorePanel.png` | HUD score strip (optional) | Wide strip (~9:1) | optional in assets.json |
| `appIcon_source.png` | App icon source for iOS handoff | 1024×1024, no transparency | — |
| `logo.png` | Admin/favicon logo | 24–32 pt / favicon | — |

---

## Layout

- **Full-screen overlays (game over, revive):** 9:16 portrait. Center in safe area; scale to fit or letterbox as needed.
- **Z-pattern:** Top → middle → bottom; primary CTA at bottom third (rule of thirds).
- **Score panel:** Anchor top-center or top-left; strip width scales with viewport; height ~1/10 of width or per art.
- **Modal (revive):** Panel centered; dimmed full-screen behind; panel has border and padding.

---

## Typography (baked in images)

- **Level 1 (headline):** "GAME OVER", "REVIVE?" — largest, blocky pixel font.
- **Level 2 (subhead / CTAs):** "PLAY AGAIN", "WATCH AD", "NO THANKS", score label — medium blocky.
- **Level 3 (detail):** Score value, fine print — smaller pixel font.
- Max 2 font families in any single screen; all pixel/blocky for consistency.

---

## Colors

- **Backgrounds:** Dark gray / black for overlays; contrast for readability.
- **Primary CTA:** Warm accent (orange/yellow) for "Play again", "Revive" / "Watch ad".
- **Secondary:** Muted for "No thanks" / "Quit".
- **Panel:** Bordered rectangle; slightly lighter than overlay background.

---

## Spacing and hierarchy

- **White space:** Padding around panel and between title / score / buttons.
- **Proximity:** Related items (e.g. score label + value) grouped; CTAs separated.
- **Focal point:** Primary button is largest and highest contrast.

---

## Component placement (SKNode hierarchy hints for C8)

- **Game over:** Single full-screen `SKSpriteNode` with texture from `gameOver.png`; or container with background + title + score (text node) + button (sprite or node). If using single texture, position at (0,0) in overlay and scale to scene size.
- **Revive:** Overlay background (dim) + centered `SKSpriteNode` for `revivePanel.png`; tap regions for Revive vs No thanks can be hit-test or separate invisible buttons over the image.
- **Score HUD:** `SKSpriteNode` with `scorePanel.png` at top; optional `SKLabelNode` for live score value on top of panel, or rely on art-only strip and draw score in code.

---

## Notes

- PNGs under `assets/ui/` are the source of truth; replace or regenerate to adjust copy or layout.
- App icon: Lane B does not edit `ios/`; another lane copies `appIcon_source.png` into `ios/CatRunner/Assets.xcassets/AppIcon.appiconset/` as needed.
- Admin logo: Use `logo.png` for favicon or header in Next.js admin (C9).
