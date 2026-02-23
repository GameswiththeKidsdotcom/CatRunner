# Many-Buildings Background and Dog/Boxes Integration

**Next hand off (cut & paste) — Lane A:** BG3+BG4 committed 2026-02-23. Lane A complete for Many-buildings-bg. Next per Master-Plan: P002 (vertical runner, viewport). Reference: [Agents/planner.md](../../../../Agents/planner.md).

**Next hand off (cut & paste) — Lane B:** Lane B complete for this plan (BG1+BG2 done). See Master-Plan for next Lane B.

---

## Goal

1. **Background image:** One (or more) background asset that shows **many buildings** — a long rooftop run so the image itself reads as multiple buildings and scrolls smoothly. Tileable for vertical runner (10+ s scroll).
2. **Integration:** Dog and boxes (obstacles) must **integrate smoothly** with the scrolling background: same world (rooftops at night), same palette and soft 2D style, and a clear "runway" so sprites sit visually on the same plane.
3. **Process:** Use [Agents/ui-designer.md](../../../../Agents/ui-designer.md) and [.cursor/skills/canva-ui-design/SKILL.md](../../../../.cursor/skills/canva-ui-design/SKILL.md) for image prompts and implementation spec.

---

## 1. Apply Canva-UI-Design Skill (explicit tie-in)

| Principle | Application for this asset |
|-----------|----------------------------|
| **Visual hierarchy** | **Focal** = cat (warm, ~44pt). **Secondary** = dog and boxes (same scale, readable on runway). **Background** = many buildings (cool, receding) — present but not competing. |
| **Color** | **Cool** (night blues/purples) for sky and buildings; **neon accents** (pink/amber/cyan) for depth; **warm** cat/obstacles so they contrast and read on top. Background uses contrast (silhouettes, values) so the lane band doesn't swallow sprites. |
| **Layout / composition** | **Rule of Thirds**: lane/runway in lower third where player runs; buildings and skyline in mid/upper. **Flow** along scroll direction (top → bottom) so the run reads clearly. |
| **White space** | **Lane band** (where cat, dog, boxes appear) is not crowded — buildings and detail recede so sprites "sit" on a clear roof plane. Denser detail in distance (skyline) is fine. |
| **Contrast** | Building silhouettes and neon are distinct in value from the **runway** so the 44pt cat, dog, and obstacle sprites remain the focus and integrate without blending into the bg. |

Reference: [.cursor/skills/canva-ui-design/SKILL.md](../../../../.cursor/skills/canva-ui-design/SKILL.md).

---

## 2. Background Image: "Many Buildings"

- **Content:** The image should depict **many buildings** — a continuous rooftop skyline (multiple roof lines, ledges, distant towers, neon signs) so that when the asset scrolls (tiled vertically), it reads as the cat running across many rooftops, not a single static screen.
- **Technical:** Tileable **vertically** (vertical runner: 200 pt/s × 10–12 s = 2000–2400 pt). Design viewport width 393 pt ([P002-VIEWPORT.md](../z-P002/P002-VIEWPORT.md)). Suggested tile height: ~400–500 pt (e.g. 800–1000 px at @2x) so 4–6 tiles cover one segment; seams must be invisible when tiled.
- **Lane band for integration:** A clear horizontal "runway" band (roof ledges/platforms) where the 5 lanes sit. This band should have **consistent value and less busy detail** so the overlaid dog and box sprites (44pt max) read clearly and feel on the same plane. Buildings and sky above/below can be denser.
- **Style:** Per [CAT-WORLD-VISION.md](../../../../assets/CAT-WORLD-VISION.md): soft cozy 2D, night blues/purples, neon accents; rooftop night. Must match existing [assets/reference/cat-world-hero-mockup.png](../../../../assets/reference/cat-world-hero-mockup.png) style.

**Deliverable:** Two files (sky.png + ground.png) per resolved decision: both show many buildings and tile vertically; ground = runway band. See §11.

---

## 3. Dog and Boxes: Smooth Integration with Scrolling Background

- **Palette:** Dog and obstacle art already follow [CAT-WORLD-VISION.md](../../../../assets/CAT-WORLD-VISION.md). No change to sprite assets unless ui-designer recommends small tint/shadow tweaks.
- **Scale:** Cat and sprites are 44pt max in code ([GameScene.swift](../../../../ios/CatRunner/Game/GameScene.swift) `SegmentSpriteMaxDimension`). Background runway band should read as same scale.
- **Composition:** Background has a **single clear runway band**; dog and boxes drawn by the game on that band (zPosition above background). No competing foreground detail in that band.
- **Implementation (B5):** GameScene adds `backgroundLayer` (zPosition < 5), vertical tiling; segment strip (zPosition 5) so sprites draw on top and scroll in lockstep with background.

Reference: [B5-backgrounds.plan.md](../../subplans/P001/B5-backgrounds.plan.md).

---

## 4. Ui-Designer Invocation and Image Prompt Structure

**Invoke:** "Use the **ui-designer** subagent to create the scrolling rooftop background asset(s) per this plan, applying the **canva-ui-design** skill."

**Image prompt structure (for GenerateImage or spec):**

1. **Subject:** Scrolling game background — many buildings, rooftop run at night; tileable vertical strip.
2. **Layout:** Portrait-oriented tile; Rule of Thirds — runway/lane band in lower third; many buildings and skyline in mid/upper; flow along vertical scroll.
3. **Style:** Soft 2D, cozy storybook; city rooftops at night; neon accents (pink, amber, cyan); no pixel art. Match cat-world hero mockup.
4. **Colors:** Cool night blues/purples; neon for depth; runway band slightly distinct value so overlaid characters (cat, dog, boxes) read clearly.
5. **Integration:** Many buildings visible; horizontal runway band for 5 lanes; scale of ledges/platforms suggestive of a ~44pt runner; tileable vertically with seamless repeat.
6. **Technical:** Dimensions for vertical tiling (e.g. width 786 px, height 800–1000 px for one tile); no text; seamless top/bottom edges.

**Outputs from ui-designer:** Image(s) and implementation spec (where to save, dimensions, tiling note, dev note for B5).

---

## 5. File and Lane Ownership

| Task | Owner | Files |
|------|--------|--------|
| Image prompt + Canva + GenerateImage | ui-designer | — |
| Save assets, update README/VISION | Lane B | assets/backgrounds/, optional README, CAT-WORLD-VISION.md |
| B5: background layer + vertical tiling | Lane A | ios/CatRunner/Game/GameScene.swift |

---

## 6. Validation

- **Asset:** Many buildings; tileable vertically; runway band clear; style matches cat-world; dimensions match spec.
- **Integration:** In simulator, after B5: background scrolls; dog and boxes on runway; no palette/scale clash; cat remains focal.
- **Ui-test:** 5-iPhone matrix per [P002-VIEWPORT.md](../z-P002/P002-VIEWPORT.md); journeys §10.

---

## 7. Rollback

- **Assets:** Revert assets/backgrounds/*.png; restore README/VISION if changed.
- **B5:** Remove background layer and tiling from GameScene; keep solid backgroundColor only.

---

## 8. Blaster alignment and chunks

**When to run:** When this initiative is ready for build, invoke Blaster for plan validation, chunking, and per-chunk fidelity.

**Chunks (build order):**

| Chunk | Description | Owner | Confidence target |
|-------|-------------|--------|-------------------|
| BG1 | Ui-designer: image prompt + Canva skill + GenerateImage; implementation spec | ui-designer | ≥90% both |
| BG2 | Lane B: Save sky.png, ground.png to assets/backgrounds/; update README/VISION if needed | Lane B | ≥90% both |
| BG3 | Lane A: B5 — background layer + vertical tiling in GameScene; runway band aligns with lanes | Lane A | ≥90% both |
| BG4 | Validation: simulator (5-iPhone), ui-test journey, screenshot baseline | ui-test + Lane A | ≥90% both |

**Detailed design:** Keep sky + ground split; both assets show many buildings and tile vertically. GameScene adds backgroundLayer (zPosition < 5), creates nodes from assetConfig.texture(forKey: "backgrounds.sky") and "backgrounds.ground"; positions and tiles by segment scroll offset.

---

## 9. Ui-designer checklist and implementation spec

**Clarifications before generating:** Dimensions (e.g. 786×900 px); two layers (sky + ground); mood/reference (cat-world hero mockup); seamless top/bottom; runway band ~25–30% of tile height.

**Implementation spec (required):** Layout (runway position, tile dimensions); colors (tokens/hex); spacing (runway height in pt); components (background layer, sky + ground nodes, tiling repeat height); dev note for B5.

Reference: [Agents/ui-designer.md](../../../../Agents/ui-designer.md).

---

## 10. Ui-test plan for this initiative

**Scope:** E2E and viewport verification of scrolling many-buildings background and dog/boxes integration. iOS-only; 5-iPhone matrix per [P002-VIEWPORT.md](../z-P002/P002-VIEWPORT.md).

**User journeys:** (1) Gameplay with scrolling background — launch → play → background visible and scrolling, cat in lane, obstacles/dog on runway, no overflow. (2) Integration check — dog/boxes on runway, no palette clash, cat focal. (3) Contrast and readability.

**Test design:** Simulator matrix; optional screenshot baseline per viewport after B5; parameterized over [Small, Standard, Large] or full 5 devices.

Reference: [Agents/ui-test.md](../../../../Agents/ui-test.md). Update [Master-Plan.md](../../Master-Plan.md) when tests are designed or complete.

---

## 11. Resolved questions

- **Asset format:** Two files (sky.png + ground.png) for quality and integration; both show many buildings and tile vertically.
- **Web vs native:** iOS-only for this initiative; ui-test scope = simulator + 5-iPhone matrix.
