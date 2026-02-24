# UI assets

HUD and overlay art per **config/default/assets.json**: `ui.revivePanel`, `ui.gameOver`, `ui.scorePanel` → `revivePanel.png`, `gameOver.png`, `scorePanel.png`. Optional: `appIcon_source.png`, `logo.png`.

**Asset dimensions:** `gameOver.png` and `revivePanel.png` are 9:16 portrait (e.g. 720×1280). `scorePanel.png` is a wide strip ~9:1 (e.g. 720×80). Create or resize source art to these aspects so in-game scaling is correct.

- **In-game HUD (C8):** Score panel, Revive dialog, Game over screen. Cat-world style per [CAT-WORLD-VISION.md](../CAT-WORLD-VISION.md): rounded panels, semi-transparent dark, neon accent; text overlaid by code. Z-pattern; 9:16 full-screen. See **implementation-spec.md** for layout, typography, and SKNode hints.
- **Optional:** App icon source (1024×1024), admin/favicon logo.
- **Spec:** [sprites-ui-assets.plan.md](../../.cursor/Plans/subplans/P001/sprites-ui-assets.plan.md) §3; [ui-mockups.plan.md](../../.cursor/Plans/subplans/P001/ui-mockups.plan.md).
