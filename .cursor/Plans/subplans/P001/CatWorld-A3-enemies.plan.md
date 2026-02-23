# CatWorld A3 — Enemies (dog.png)

**Next hand off:** Execute after A2. When done, Master-Plan Lane B points to A4.

## Goal

Replace placeholder dog sprite with one city-dog enemy: soft 2D, slightly threatening but not scary, player-sized.

## Steps

1. Build prompt: stylized city dog (stray or guard); soft cozy 2D; rounded; size comparable to player (~132px); transparent BG.
2. Generate and save to `assets/dogs/dog.png`.
3. Optionally update `assets/dogs/README.md` with cat-world style note.

## Path

- `assets/dogs/dog.png` — Config: `enemies.dog` (no change).

## Validation

- File exists; dog reads as enemy; style consistent with character and obstacles.

## Rollback

- `git checkout -- assets/dogs/dog.png`

## Confidence

- **Confidence (root cause):** N/A
- **Confidence (solution path):** High
