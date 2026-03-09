# C1 — Extend transparency script to all character assets

**Done (2026-03-09).** Script extended; run verified; `sips -g hasAlpha` returns yes for cat_run.png, cat_jump.png, cat_slide.png. See Master-Plan Lane B for next task (SeamlessBackground C1).

---

**Chunk of:** [CatTransparency-TransparencyAndBackgroundFix.plan.md](CatTransparency-TransparencyAndBackgroundFix.plan.md)

---

## Outcome

- `cat_run.png`, `cat_jump.png`, `cat_slide.png` have `hasAlpha: yes`
- Idle cat has no visible box

---

## Steps

1. Edit [scripts/add-transparency-to-cat-frames.py](scripts/add-transparency-to-cat-frames.py): add patterns for `cat_run.png`, `cat_jump.png`, `cat_slide.png` (or include in the file list).
2. Run `python3 scripts/add-transparency-to-cat-frames.py`
3. Verify `sips -g hasAlpha assets/character/cat_run.png` returns `hasAlpha: yes`

---

## Detailed Design

**Current patterns (lines 91–96):**
```python
patterns = [
    os.path.join(assets_dir, "cat_jump_*.png"),
    os.path.join(assets_dir, "cat_slide_*.png"),
]
```

**Change:** Add explicit paths for single-texture assets:
```python
single_files = ["cat_run.png", "cat_jump.png", "cat_slide.png"]
files = [os.path.join(assets_dir, f) for f in single_files if os.path.exists(os.path.join(assets_dir, f))]
for p in patterns:
    files.extend(sorted(glob.glob(p)))
files = sorted(set(files))  # dedupe if cat_jump.png matches glob
```

Or simpler: add `cat_run.png` and `cat_slide.png` (cat_jump.png may match cat_jump_*.png and be processed; verify glob order). Safer: add explicit list for single files, then extend with globs.

---

## Confidence

| | Confidence (root cause) | Confidence (solution path) |
|---|-------------------------|----------------------------|
| C1 | N/A (feature) | 95% |

**Note:** Script logic proven on 16 frames; extension is additive.

---

## Rollback

`git checkout -- assets/character/cat_run.png assets/character/cat_jump.png assets/character/cat_slide.png`
