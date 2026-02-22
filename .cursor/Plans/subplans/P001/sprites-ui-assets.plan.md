# Sprites and UI Objects — Creation Plan (P001)

**Next hand off (Lane B):** Hand off to C9 when ready. Lane B deliverables done: (1) `config/default/assets.json` created with path map from §6 (C2 step 4). (2) Asset directories under `assets/` scaffolded (character, dogs, backgrounds, powerups, ui; obstacles already had README). Placeholder/final sprite generation remains optional—use ui-designer subagent as needed.

---

## Scope

Single source of truth for asset inventory, path map for `assets.json`, and ui-designer workflow. **This plan does not create files or code:** C2 creates `config/default/assets.json` using §6; ui-designer or Lane B creates image assets under `assets/`.

---

## 1. Asset inventory (source of truth)

The Master-Plan and config define these asset groups. **`config/default/assets.json`** is created by C2 (step 4); its path map content is defined only in this plan (§6). C2 creates the file; do not duplicate the path list in C2-config.plan.md.

| Category | Path | Chunk | Current state |
|----------|------|-------|----------------|
| Character | `assets/character/` | C1 or C9 | Not created; player uses color rect |
| Obstacles | `assets/obstacles/` | C4 | README only; 3 types |
| Enemies | `assets/dogs/` | C1 or C4 | Not created |
| Backgrounds | `assets/backgrounds/` | C1 | Not created |
| UI | `assets/ui/` | C1 or C8 | Not created |
| App icon | `ios/CatRunner/Assets.xcassets/AppIcon.appiconset/` | C1 | Placeholder (1024×1024 slot) |

Power-ups (**speedBoost**, **shield**) are in config but not in Master-Plan asset list; add **`assets/powerups/`** (or `assets/ui/` subfolder) and include in `assets.json`.

---

## 2. Sprites and corresponding images

### 2.1 Character (player cat)

- **Object:** PlayerNode (SKSpriteNode) — "Replace with texture in later chunks."
- **Size:** 44×44 pt (reference); art @1x, @2x, @3x.
- **Images:** Idle/run (default cat); optional later: jump frame, slide frame (C7).
- **Style:** Cat, recognizable at small size; playful/casual. PNG, transparency; `SKTexture(imageNamed:)` or asset catalog.

### 2.2 Obstacles (3 types)

Per `assets/obstacles/README.md` and `config/default/variant.json`: **passable** (jump-over), **instantFail** (collision), **slowdown** (e.g. mud). One sprite each; base ~88–132 pt wide; PNG.

### 2.3 Enemies (dogs)

- **Path:** `assets/dogs/`. At least one dog sprite; size comparable to player; consistent style with cat.

### 2.4 Backgrounds

- **Path:** `assets/backgrounds/`. One or more layers (sky, mid, ground); tileable or viewport-wide; aspect e.g. 9:16.

### 2.5 Power-ups

- **Types:** speedBoost, shield. In-lane sprites; optional HUD icons in `assets/ui/`. In-lane ~44–60 pt; icon ~24–32 pt.

---

## 3. UI objects and corresponding images

### 3.1 In-game HUD (C8)

Score display (text or score panel art); Revive dialog (panel/overlay, CTAs); Game over screen (title, score, Play again). Use ui-designer Image Prompt Structure; Z-pattern; 9:16 if full-screen.

### 3.2 App icon and brand

App icon 1024×1024 PNG, no transparency. Optional: favicon/logo for admin in `assets/ui/`.

### 3.3 Admin panel (C9)

No sprite assets; brand/logo in `assets/ui/` if needed. ui-designer for implementation specs (layout, typography, colors).

---

## 4. Image creation workflow (ui-designer)

Follow **Image Prompt Structure** from [Agents/ui-designer.md](../../../Agents/ui-designer.md): Subject, Layout, Style, Typography, Colors, Technical (aspect ratio, dimensions). Apply **canva-ui-design** skill for UI mockups. Clarify before generating: art style, palette, aspect ratio, text in-image vs code.

---

## 5. Implementation specs (deliverables)

- **Sprites:** Path under `assets/*`, size in points, code use (e.g. `SKTexture(imageNamed:)`).
- **UI in-game:** Layout, typography, colors, SKNode hierarchy.
- **App icon:** 1024×1024 PNG → AppIcon.appiconset.
- **Admin/brand:** Path, size, Tailwind/CSS if used in Next.js.

---

## 6. Suggested asset path map (`assets.json`)

- character.run → `assets/character/cat_run.png`
- obstacles.passable / instantFail / slowdown → `assets/obstacles/*.png`
- enemies.dog → `assets/dogs/dog.png`
- backgrounds.sky / ground → `assets/backgrounds/`
- powerups.speedBoost / shield → `assets/powerups/` or `assets/ui/`
- ui.revivePanel / ui.gameOver → `assets/ui/` (optional)
- appIcon → iOS asset catalog (separate)

---

## 7. Validation and risks

- **Validation:** Sprite exists, loads in SpriteKit, correct z-order/size; UI correct aspect ratio and tappable CTAs.
- **Risks:** Style inconsistency across batches; recommend style guide. Missing `assets.json` until C2 — use this path list as spec.
- **Rollback:** Replace textures with nil/color rect (as PlayerNode); swap assets if paths are config-driven.

---

## Confidence

- **Confidence (root cause):** N/A (design/spec plan).
- **Confidence (solution path):** High for inventory; Medium for image specs (dimensions may tune with C4/C6/C7/C8).
