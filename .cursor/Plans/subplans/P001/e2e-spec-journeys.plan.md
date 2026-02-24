---
name: E2E spec assessment and journeys
overview: Assess the specification, create a skeleton of E2E user journeys per feature (iOS game and Admin), list what must be answered before building E2E, and add investigation plans and question sets. Aligned with logic-test, ui-test, and Blaster (CatRunner scope).
---

**Next hand off (cut & paste):** Tier 4 done (2026-02-24). **Optional Lane A (5-iPhone matrix + lane IDs) — verified (2026-02-24);** see [optional-lane-a-verification.plan.md](optional-lane-a-verification.plan.md). See [Master-Plan.md](../../Master-Plan.md) "Next hand off — Lane A". E2E (J1–J5 iOS, J6–J9 Admin) and Tiers 1–4 complete. Keep Master-Plan and this prompt in sync per [Agents/planner.md](../../../Agents/planner.md).

**Path to archive (supporting docs):** When E2E work is fully closed and Tier 2–4 no longer need [e2e-investigation-findings-2026-02-23.md](e2e-investigation-findings-2026-02-23.md), move that doc to `subplans/P001/zz-archive/`. This plan remains active for reference until all journey work is complete.

---

# E2E Specification Assessment and User-Journey Skeleton

## 1. Specification assessment

**Current state:** [docs/SPECIFICATION.md](../../../docs/SPECIFICATION.md) exists (C12 done). This plan derives E2E scope from Master-Plan, [P001-CatRunner.plan.md](P001-CatRunner.plan.md), C7/C8/C9/C12 plans, [config/default/variant.json](../../../config/default/variant.json), and [assets/ui/implementation-spec.md](../../../assets/ui/implementation-spec.md).

**Implied scope (per C12):** Game concept and rules; VariantConfig schema; engine architecture; procedural generation rules; admin capabilities; CI/CD steps; testing requirements; asset structure; monetization/Live Ops schema; rollback, risks, validation.

**What exists today:**

| Area | Source | Completeness |
|------|--------|--------------|
| Game rules (5 lanes, obstacles, power-ups) | variant.json, C4–C7 plans | High: types, spans, jump/slide, collision |
| Difficulty and scoring | C8 plan, variant.json difficultyScaling | Medium: scaling params; scoring formula and HUD behavior not fully specified |
| Revive and game over | C8 plan, ui implementation-spec | Medium: revive offer (IAP/ad stub); CTAs "Watch ad", "No thanks", "Play again"; exact flow and resume state TBD |
| iOS entry and HUD | C1, implementation-spec | Low: no written spec for title/menu vs tap-to-start; score panel placement and live score visibility |
| Admin flows | C9 plan, config/admin.json | Medium: routes and pages listed; save semantics (commit vs file write), auth, and "active variant" TBD |
| Viewport/device | e2e-harness, test-harness plan | Low: qualitative harness prefers one simulator; full matrix not defined |

**Gaps for E2E:** Entry points and success criteria for each journey are underspecified; user-usable object list (tap targets, selectors) and viewport matrix are not documented. These are captured below as investigation plans and question sets.

---

## 2. E2E user-journey skeleton by feature

### 2.1 iOS game (CatRunner app)

| Journey ID | Feature | Entry | Steps (skeleton) | Exit | Success criteria (to be confirmed) |
|------------|---------|--------|------------------|------|-------------------------------------|
| **J1** | App launch / start | Cold launch | 1. Launch app. 2. (If menu) tap Start/Play. 3. Game scene visible, cat in lane, lanes scroll or obstacles approach. | Gameplay active | Scene visible; player in lane 2; no crash. |
| **J2** | Gameplay (run, move, score) | Gameplay active | 1. Lane swap (tap/swipe left or right). 2. Jump (tap/gesture). 3. Slide (tap/gesture). 4. Observe score (HUD). 5. Optional: collect power-up. | Same or game over | Inputs affect state; score updates; at least one obstacle type visible. |
| **J3** | Collision → game over or revive | Gameplay active | 1. Hit instant-fail obstacle (or simulate). 2. Game over or Revive dialog appears. | Revive dialog or Game over screen | Correct overlay (revive vs game over) per collision type. |
| **J4** | Revive flow | Revive dialog visible | 4a. Tap "Watch ad" (or IAP) → resume gameplay. 4b. Tap "No thanks" → Game over screen. | Gameplay or Game over | Resume from checkpoint/lane; or game over with score. |
| **J5** | Game over → play again | Game over screen visible | 1. Tap "Play again". 2. New run starts (same or reset state). | Gameplay active (J1/J2) | New run; score reset or high score persisted per spec. |

**User-usable objects (iOS) — to be confirmed:** Lane-swap regions (left/right or buttons); jump and slide controls (gesture or button); score HUD (read-only); Revive dialog CTAs ("Watch ad", "No thanks"); Game over CTA ("Play again"). All must be tappable and in viewport (per [Agents/e2e-harness.md](../../../Agents/e2e-harness.md)).

### 2.2 Admin panel (Next.js)

| Journey ID | Feature | Entry | Steps (skeleton) | Exit | Success criteria (to be confirmed) |
|------------|---------|--------|------------------|------|-------------------------------------|
| **J6** | Variant list | Admin base URL | 1. Open admin (e.g. /admin). 2. View list: default + variants/*. 3. Optional: select active variant. | List displayed | Default and easy.json (or current variants) visible. |
| **J7** | Config editor | Admin or variant list | 1. Open config editor (default variant or chosen). 2. Load variant.json. 3. Edit (form or JSON). 4. Validate (schema). 5. Save (commit or file write). | Saved or error | Validation runs; save semantics documented. |
| **J8** | Asset upload | Admin | 1. Choose asset path (from assets.json keys or dropdown). 2. Upload file. 3. Confirm file at path. | File in assets/ | File appears at correct path; path map respected. |
| **J9** | CI trigger | Admin | 1. Open CI trigger link or button. 2. workflow_dispatch or docs. | External or doc | Link works; no E2E into GitHub. |

**User-usable objects (Admin) — to be confirmed:** Nav or links (Variant list, Config editor, Asset upload, CI); variant list rows/links; editor textarea or form fields; Save button; upload input and path selector; CI link/button.

---

## 3. What needs to be answered before we can build E2E

- **iOS:** (1) Is there a title/menu screen or immediate tap-to-start? (2) Exact input model: tap zones for lane/jump/slide vs gestures only? (3) Revive: one tap per CTA; resume state (checkpoint vs lane)? (4) Stable selectors or accessibility identifiers for all CTAs and key HUD elements? (5) Safe area and layout for smallest supported device?
- **Admin:** (1) Entry URL and auth (if any). (2) Save: local file write only, or git commit (and how)? (3) How is "active variant" determined and used by the app? (4) Asset upload: which keys in assets.json are editable; any validation (type, size)?
- **Harness:** (1) Viewport/device matrix: one simulator (e.g. iPhone 16) for qualitative harness vs more? (2) Which journeys run on every PR vs nightly? (3) Screenshot baselines: which screens require pixel/screenshot checks?

---

## 4. Investigation plans and question sets

### Investigation 1: iOS entry, HUD, and controls (J1, J2)

**Goal:** Lock entry point, HUD visibility, and input model so E2E can drive the game.

**Question set:** (1) On app launch, title/menu or immediate game scene (tap-to-start)? (2) Lane swap, jump, slide: tap zones vs swipe vs buttons? (3) Score position and always visible? (4) Accessibility identifiers or stable IDs for lane regions, jump, slide, score, Start button? (5) Smallest device or minimum viewport (e.g. iPhone SE, 9:16)?

**Deliverable:** Short spec or table: entry (menu vs immediate), input map (action → control), HUD layout, selector/ID strategy. Update SPECIFICATION.md or implementation-spec.

**Owner:** Lane A (ios/) or Investigator; can involve ui-test for viewport/accessibility.

### Investigation 2: Revive and game-over flows (J3, J4, J5)

**Goal:** Define exact screens, CTAs, and state transitions so E2E can assert on revive and play-again.

**Question set:** (1) Revive dialog always first on instant-fail, or only when monetization configured? (2) Revive button labels and count ("Watch ad", "No thanks" only, or also "Quit")? One tap per button? (3) After "Watch ad": resume same lane/segment or checkpoint? Countdown or immediate? (4) Game over: besides "Play again", "Quit" or "Menu"? (5) After "Play again": full reset (score, segment, difficulty)? High score persisted?

**Deliverable:** State diagram or table: collision → revive vs game over; revive accept/decline → state; play again → state. Document in C8 plan or SPECIFICATION.md.

**Owner:** Lane A (ios/) or Investigator; logic-test can validate state consistency.

### Investigation 3: Admin entry, auth, save, and active variant (J6, J7, J9)

**Goal:** Define admin entry, save semantics, and active variant so E2E can drive config editor and variant list.

**Question set:** (1) Admin base URL and auth? If auth, how does E2E get a session? (2) Config save: dev = local file write; prod = "document commit"? (3) How does iOS app know which variant to load? Where is "active variant" defined? (4) Variant list "active" = used by app or last edited? (5) CI trigger: workflow_dispatch link or docs? E2E assert link presence and non-404?

**Deliverable:** Admin spec snippet: URLs, auth (or none), save behavior (dev vs prod), active-variant definition, CI link behavior. Update C9 plan or SPECIFICATION.md.

**Owner:** Lane that owns admin (src/) or Investigator; no ios/ change.

### Investigation 4: Viewport matrix and E2E scope (all journeys)

**Goal:** Keep harness qualitative and fast; decide which devices and which journeys run when.

**Question set:** (1) One simulator (e.g. iPhone 16, portrait) sufficient for iOS E2E, or second size? (2) Which iOS journeys (J1–J5) run on every PR vs nightly? (3) Admin viewports (e.g. desktop 1280px, one mobile breakpoint)? (4) Screenshot baselines for any screen (game over, revive) or "element present and tappable" enough?

**Deliverable:** Viewport/device matrix table and E2E scope (per journey: PR vs nightly; screenshot Y/N). Align with qualitative, fast test harness.

**Owner:** Planner or e2e-harness; can involve infrastructure for CI stability.

**Implementation (2026-02-24):** (1) **5-iPhone E2E matrix** — CI job `test-ios-matrix` in [.github/workflows/test.yml](../../../.github/workflows/test.yml) runs full test suite (unit + UI) on 5 simulators: iPhone SE (3rd generation), iPhone 14, iPhone 15, iPhone 16, iPhone 16 Pro Max; `fail-fast: false` so one device failure does not cancel others. (2) **Lane accessibility IDs** — GameViewController adds overlay views `LaneTapLeft` and `LaneTapRight` (accessibilityIdentifier) that call GameScene.moveLaneLeft()/moveLaneRight(); E2E can tap by ID. JourneyTests adds testJ2_LaneTapRegions_ExistAndTappable. (3) **Viewport matrix table** (below).

| Device / viewport | Scope | PR | Screenshot |
|-------------------|-------|-----|------------|
| iPhone SE (3rd gen) | iOS J1–J5 + unit | test-ios-matrix | N |
| iPhone 14 | iOS J1–J5 + unit | test-ios-matrix | N |
| iPhone 15 | iOS J1–J5 + unit | test-ios-matrix | N |
| iPhone 16 | iOS J1–J5 + unit | test (primary) + test-ios-matrix | N |
| iPhone 16 Pro Max | iOS J1–J5 + unit | test-ios-matrix | N |
| Desktop 1280 / 1440 | Admin J6–J9 | admin-e2e | N |

---

## 5. Dependency and handoffs

- **SPECIFICATION.md** (C12) can absorb answers from Investigations 1–3.
- **Investigations 1–3** unblock concrete E2E implementation (steps, selectors, success criteria).
- **Investigation 4** unblocks CI and viewport scope; can proceed in parallel.
- **Handoffs:** After investigations, invoke **ui-test** for Admin (web) E2E implementation; **logic-test** for state/rules validation (revive, play again); **e2e-harness** when implementing to keep journeys minimal and stable. See §6 (logic-test and ui-test alignment) and §7 (Blaster pipeline).

---

## 6. Logic-test and ui-test alignment

### 6.1 Logic-test validation targets

When **logic-test** is invoked for journeys J2–J5 (gameplay, collision, revive, play again), validate:

- **Allowed moves only when rules permit:** Revive dialog offered only when rules say so (e.g. when monetization configured); no move offered if game state does not allow it.
- **No unreachable valid states:** Every rule-valid outcome reachable (e.g. "Play again" from game over; "Resume gameplay" after "Watch ad"); no dead ends.
- **State consistency after transitions:** After "Watch ad" → resume, game state (lane, segment, score) matches spec. After "Play again" → new run, reset and high-score persistence match spec.

**Handoff:** After Investigation 2, invoke logic-test with: "Use the logic-test subagent to ensure test plans are made for CatRunner game logic, move validation, and state-machine (1-player endless runner): validate allowed moves for revive/game over, unreachable valid states, and state consistency after revive and play again per the E2E journey plan Investigation 2 deliverable."

### 6.2 Ui-test scope and tooling

- **Admin (J6–J9):** **ui-test** owns E2E implementation for Next.js admin. Use **Playwright** for J6–J9. Layout, contrast, viewports apply to admin pages.
- **iOS (J1–J5):** CatRunner iOS is a **native** app. **Playwright does not apply to iOS.** Implement iOS E2E with **native tooling** (e.g. XCUITest). When invoking ui-test for a chunk that includes iOS, scope ui-test to **Admin only** (Playwright); iOS E2E is implemented by builder or Lane A with XCUITest per this plan.
- **Viewport/device matrix:** For CatRunner, **override** ui-test default "newest 3" with **Investigation 4 deliverable** (qualitative harness, fast). When invoking ui-test for CatRunner, specify: "Use the viewport matrix from the E2E plan Investigation 4 deliverable (qualitative, fast); do not apply the full newest-3 matrix unless the project overrides."

---

## 7. Blaster pipeline alignment

This plan is for **P001 CatRunner** (1-player endless runner, 5 lanes, single avatar). When [Agents/blaster.md](../../../Agents/blaster.md) is invoked for this plan or E2E-related chunks:

- **Scope:** Use **CatRunner scope** (1 player, 5 lanes, procedural segments, single avatar). Do not assume 2 players or 2 boards.
- **Step 2 (Test plans):** Invoke ui-test for **Admin E2E and viewports** (Playwright, Investigation 4 matrix). Invoke logic-test for **game logic and state-machine** (revive, game over, play again; see §6.1 validation targets). Invoke infrastructure for CI/harness stability.
- **Step 5 (Per-chunk fidelity):** For chunks touching E2E or journeys (e.g. C8 revive, C9 admin), run Investigator, ui-test (Admin scope), logic-test (state/rules per §6.1), infrastructure, e2e-harness. Ui-test confirms **Admin** coverage; **iOS** E2E coverage via e2e-harness and native test stack, not Playwright.
- **Confidence:** Investigator evaluates each chunk; persist **Confidence (root cause)** and **Confidence (solution path)** to chunk sub-plan and Master-Plan **P001 Build Chunk Progress**.
- **Invocation examples (CatRunner scope):**
  - ui-test: "Use the ui-test subagent to ensure test plans are made for CatRunner admin (E2E, viewports). Use the viewport matrix from the E2E plan Investigation 4 deliverable (qualitative harness). iOS E2E is native (XCUITest); scope Playwright to admin only."
  - logic-test: "Use the logic-test subagent to ensure test plans are made for CatRunner game logic, move validation, and state-machine (1-player): revive/game over allowed moves, unreachable valid states, state consistency after revive and play again per E2E plan §6.1."

---

## 8. Summary

| Output | Description |
|--------|-------------|
| Spec assessment | SPECIFICATION.md referenced; implied spec and gaps listed. |
| Journey skeleton | J1–J5 (iOS): launch, gameplay, collision, revive, play again. J6–J9 (Admin): variant list, config editor, asset upload, CI trigger. |
| Open questions | Entry/menu, controls, revive state, admin auth/save, active variant, viewport matrix, screenshot needs. |
| Investigation plans | 4 plans: (1) iOS entry/HUD/controls, (2) Revive/game over, (3) Admin entry/auth/save, (4) Viewport and E2E scope. Each has question set and deliverable. |
| Logic-test targets | §6.1: Allowed moves when rules permit; no unreachable valid states; state consistency after revive and play again. |
| Ui-test scope | §6.2: Admin (J6–J9) = Playwright; iOS (J1–J5) = native (XCUITest); viewport matrix from Investigation 4 (override ui-test default). **Implementation:** `ios/CatRunnerUITests/JourneyTests.swift` (7 tests incl. J2 lane-tap); `LaneTapLeft`/`LaneTapRight` in GameViewController; launch arg `ForceGameOver` for J3–J5. **5-iPhone matrix:** job `test-ios-matrix` (SE, 14, 15, 16, 16 Pro Max). |
| Blaster alignment | §7: CatRunner scope (1-player); ui-test for Admin + Investigation 4 matrix; logic-test per §6.1; confidence persisted per chunk. |

Resolving the four investigation question sets will provide enough specificity to build a minimal, qualitative E2E harness. When Blaster runs the plan-validation pipeline on E2E-related work, use §6 and §7 for agent scope and invocation wording.

---

## Confidence

- **Confidence (root cause):** N/A (design/spec plan; investigations will close gaps).
- **Confidence (solution path):** High — journey skeleton and agent alignments (logic-test, ui-test, Blaster) are defined; implementation unblocked by investigations.
