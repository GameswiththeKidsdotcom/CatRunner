# P001-E2E Investigation Findings — 2026-02-23 (Lane A, read-only)

Per [e2e-spec-journeys.plan.md](e2e-spec-journeys.plan.md) §4 (Investigation 1–4). Evidence from codebase; confidence and gaps noted. Use to update SPECIFICATION.md or implementation-spec and to invoke ui-test (Admin) and logic-test.

---

## Investigation 1: iOS entry, HUD, and controls (J1, J2)

| Question | Finding | Confidence | Gap |
|----------|---------|------------|-----|
| (1) Title/menu vs immediate game scene? | **Immediate game scene.** AppDelegate → GameViewController → GameScene; no title/menu; no tap-to-start. `GameViewController.viewDidLoad` presents `GameScene` directly. | High | None |
| (2) Lane swap, jump, slide: tap vs swipe vs buttons? | **Swipe only.** `GameScene`: `touchesBegan`/`touchesEnded`; `swipeMinDistance = 30` pt. Up = jump, down = slide, left/right = lane. No tap zones or on-screen buttons. | High | E2E must drive swipes (direction + distance). |
| (3) Score position and always visible? | **Not in-scene.** Score is in `ScoreKeeper`; exposed as `scene.currentScore` / `scene.highScore`. Shown **only in Game Over alert** message. No SKLabelNode or scorePanel texture drawn in GameScene. assets.json has `ui.scorePanel` path but not wired as HUD. | High | Spec/impl: add in-game score HUD or document "score in alert only". |
| (4) Accessibility identifiers or stable IDs? | **None.** No `accessibilityIdentifier` or `accessibilityLabel` in `ios/`. | High | Add identifiers for lane regions, (future) buttons, and alert CTAs for XCUITest. |
| (5) Smallest device / minimum viewport? | **Design size 393×852** (GameViewController); aspectFit. P002 viewport doc: iPhone SE (3rd gen) 375×667; 5-iPhone matrix (SE, 14, 15, 15 Plus, 15 Pro Max). | High | Document "min supported = iPhone SE (3rd gen)" in spec. |

**Deliverable (short):** Entry = immediate game scene. Input = swipe only (up/down/left/right, 30pt min). HUD = score only in game-over alert today; no in-game score node. No accessibility IDs yet — add for E2E. Min viewport = iPhone SE (3rd gen) per P002.

---

## Investigation 2: Revive and game-over flows (J3, J4, J5)

| Question | Finding | Confidence | Gap |
|----------|---------|------------|-----|
| (1) Revive always first on instant-fail, or only when monetization configured? | **Always one alert.** Instant-fail → `gameDelegate?.gameSceneDidRequestGameOver(self)` → `showReviveOrGameOver`. Single UIAlertController with "Revive" and "Done". No branch on monetization config in current code. | High | SPEC says "revive (IAP or rewarded ad per monetization config)" — not yet wired. |
| (2) Revive button labels? | **"Revive"** and **"Done"** (not "Watch ad", "No thanks", "Quit"). One tap per button. | High | E2E spec expected "Watch ad"/"No thanks"; align spec or UI. |
| (3) After "Revive": resume state? | **Checkpoint resume.** `scene.resumeFromCheckpoint()` restores segment (segment index + seed), clears `gameOverRequested`, restarts segment. Same lane/segment; no countdown. | High | None |
| (4) Game over: "Play again" or "Quit"/"Menu"? | **Only "Done".** Dismisses alert; **no "Play again"**. No new run started from UI. | High | **Play-again flow missing** — critical for J5. |
| (5) After "Play again": full reset? High score persisted? | **N/A** — no Play again. `ScoreKeeper` persists high score in UserDefaults; `resetCurrentRun()` exists (currentScore = 0, high score unchanged). | — | Implement "Play again" → reset current run and present new game (e.g. new GameScene or restart). |

**Deliverable (short):** State: instant-fail → one alert (Revive | Done). Revive → resumeFromCheckpoint(). Done → alert dismisses only; no play-again. **Gap:** Add "Play again" CTA and wire to full run reset; document high-score persistence (already implemented). Logic-test: validate allowed moves and state after revive/play-again once implemented.

---

## Investigation 3: Admin entry, auth, save, and active variant (J6, J7, J9)

| Question | Finding | Confidence | Gap |
|----------|---------|------------|-----|
| (1) Admin base URL and auth? | **Base URL:** `/admin` (Next.js). `src/app/admin/page.tsx` — dashboard with links to config, assets, variants, ci. **Auth:** No auth in code (no middleware or auth check on admin routes). | High | If E2E needs auth, add or document "no auth in dev". |
| (2) Config save: dev file write vs prod commit? | **API:** `src/app/api/admin/config/route.ts` exists. Need to confirm GET/POST behavior (read/write to `config/default/variant.json`). Typically file write in repo; no git commit in app unless implemented. | Medium | Read API implementation; document save semantics. |
| (3) How does iOS app know which variant to load? | **Bundle default only.** Build phase copies `config/default/` into app bundle; iOS loads from bundle. No "active variant" selector in app. Admin has variants dir for listing/editing. | High | "Active variant" = default variant in bundle for iOS; admin edits default or variant files. |
| (4) Variant list "active" = used by app or last edited? | **Not defined in app.** Admin shows variant list; "active" for app = whatever is in bundle (default). | High | Document: active = config loaded by app (bundle default); admin "active" is UX only unless CI deploys selected variant. |
| (5) CI trigger: workflow_dispatch link? | **admin.json:** `ciTrigger`, `ciWorkflowUrl: ""`. Admin CI page exists (`/admin/ci`). E2E can assert link presence and non-404. | Medium | Confirm CI page content; fill ciWorkflowUrl if needed. |

**Deliverable (short):** Admin = `/admin`, no auth. Save = file write (confirm in config API). Active variant for iOS = bundle default. CI = link to workflows; E2E assert link present. Lane A does not own admin (src/); Investigator or Lane B can update C9 plan.

---

## Investigation 4: Viewport matrix and E2E scope (all journeys)

| Question | Finding | Confidence | Gap |
|----------|---------|------------|-----|
| (1) One simulator for iOS E2E or more? | **CI (test.yml):** iPhone 16, OS=latest. **P002 viewport:** 5 iPhones (SE 3rd, 14, 15, 15 Plus, 15 Pro Max); 58 tests pass on SE and 15 Pro Max. | High | E2E: one simulator (e.g. iPhone 16) for PR; optional second (e.g. SE) for nightly. |
| (2) Which iOS journeys run on every PR vs nightly? | **Not defined.** Recommend: J1 (launch) + J2 (one swipe/jump) on every PR; J3–J5 (revive/play again) when implemented, PR or nightly. | — | Add to E2E plan. |
| (3) Admin viewports? | **Not defined.** Recommend: desktop 1280×720 or 1440×900 for Admin (Playwright); one mobile breakpoint optional. | — | Add to Investigation 4 deliverable. |
| (4) Screenshot baselines? | **P002:** Optional screenshot per device. E2E: "element present and tappable" may suffice; screenshot for game-over/revive when stable. | Medium | Decide per journey; document in plan. |

**Deliverable (short):** iOS: one simulator (iPhone 16) for PR; 5-iPhone matrix for manual/viewport validation per P002. Admin: desktop 1280 or 1440; Playwright. Screenshot baselines optional; prefer element-present for stability.

---

## Next actions (Lane A and agents)

1. **SPECIFICATION.md / implementation-spec:** Update with Investigation 1–2–3–4 deliverables above (entry, input, HUD, revive/play-again state, admin, viewport).
2. **Lane A (ios/):** Add "Play again" flow; optionally add accessibility identifiers and in-game score HUD per spec.
3. **Invoke ui-test (Admin):** Implement Playwright E2E for J6–J9 (variant list, config editor, asset upload, CI link); viewport per Investigation 4.
4. **Invoke logic-test:** Validate game logic and state-machine for revive and play-again (allowed moves, unreachable states, state consistency) per e2e-spec-journeys.plan.md §6.1 once play-again is implemented.

---

## Confidence summary

- **Investigation 1:** High (code-inspected). Gaps: HUD and accessibility IDs.
- **Investigation 2:** High (code-inspected). Gap: Play-again flow missing; CTA labels vs spec.
- **Investigation 3:** High for entry/variant; Medium for save/CI until API read.
- **Investigation 4:** High for iOS matrix; scope (PR vs nightly) and Admin viewport to be set in plan.
