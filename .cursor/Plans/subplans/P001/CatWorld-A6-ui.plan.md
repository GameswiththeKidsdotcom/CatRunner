# CatWorld A6 — UI panels (scorePanel, gameOver, revivePanel)

**Next hand off:** Execute after A5. When done, Master-Plan Lane B points to A7.

## Goal

Replace UI overlay art with cat-world style: rounded panels, semi-transparent dark, neon accent (pink or amber); 9:16 for overlays; wide strip for score panel.

## Steps

1. **scorePanel.png** — Prompt: HUD score strip, wide horizontal panel; rounded; dark semi-transparent; neon accent; soft 2D; no or minimal text (code can overlay). Aspect ~9:1 wide. Save to `assets/ui/scorePanel.png`.
2. **gameOver.png** — Prompt: game over overlay, 9:16 portrait; rounded central panel; dark BG, neon accent; space for “GAME OVER” and “RUN AGAIN” (or leave for code). Save to `assets/ui/gameOver.png`.
3. **revivePanel.png** — Prompt: revive dialog overlay, 9:16; rounded panel; “REVIVE?” / “WATCH AD” / “NO THANKS” placeholder or leave for code. Save to `assets/ui/revivePanel.png`.
4. Optionally update `assets/ui/README.md` or implementation-spec with cat-world style note.

## Paths

- `assets/ui/scorePanel.png`, `gameOver.png`, `revivePanel.png` — Config: `ui.scorePanel`, `ui.gameOver`, `ui.revivePanel` (no change).

## Validation

- All three files exist; aspect ratios correct; style consistent with CAT-WORLD-VISION.

## Rollback

- `git checkout -- assets/ui/scorePanel.png assets/ui/gameOver.png assets/ui/revivePanel.png`

## Confidence

- **Confidence (root cause):** N/A
- **Confidence (solution path):** High
