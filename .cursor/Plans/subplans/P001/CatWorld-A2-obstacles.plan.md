# CatWorld A2 — Obstacles (passable, instantFail, slowdown)

**Next hand off:** Execute after A1. When done, Master-Plan Lane B points to A3.

## Goal

Replace three obstacle sprites with rooftop-themed, soft cozy 2D art: passable (harmless clutter), instantFail (vent/gap/danger), slowdown (puddle/sticky).

## Steps

1. **passable.png** — Prompt: small crates/boxes or harmless rooftop clutter; centered; soft 2D; ~132px wide; transparent. Save to `assets/obstacles/passable.png`.
2. **instantFail.png** — Prompt: rooftop hazard (vent, gap, or danger); same style and size. Save to `assets/obstacles/instantFail.png`.
3. **slowdown.png** — Prompt: puddle, wet patch, or sticky spot; same style and size. Save to `assets/obstacles/slowdown.png`.
4. Optionally update `assets/obstacles/README.md` with cat-world style note.

## Paths

- `assets/obstacles/passable.png`, `instantFail.png`, `slowdown.png`
- Config: `obstacles.passable`, `obstacles.instantFail`, `obstacles.slowdown` (no change).

## Validation

- All three files exist; each reads as intended type; consistent soft rounded style.

## Rollback

- `git checkout -- assets/obstacles/*.png`

## Confidence

- **Confidence (root cause):** N/A
- **Confidence (solution path):** High
