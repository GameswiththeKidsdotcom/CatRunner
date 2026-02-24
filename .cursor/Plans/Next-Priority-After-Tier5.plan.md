# Next priority after Tier 5 — Planner output

**Date:** 2026-02-24  
**Context:** Tier 5 (T5-C1 through T5-C9) complete; committed and pushed. No next tier or roadmap item was defined in Master-Plan.

---

## 1. Current state

- **Tiers 1–5:** Complete (Master-Plan prioritized roadmap).
- **Tier 5:** Tech debt and consolidation (T5-C1–T5-C9) done; commit pushed to `main`.
- **Mandatory Lane A:** None. Roadmap has no Tier 6 or next item.
- **Lane B:** No current task; invoke planner when config/ or assets/ work is defined.

---

## 2. Next priority (mandatory)

**None.** No Tier 6 or next roadmap item is defined. When the product owner or planner is ready, define one of:

- **Option A — New tier (e.g. Tier 6):** Add a row to Master-Plan "Prioritized roadmap" with goal and deliverables (e.g. polish, store listing, analytics, new feature).
- **Option B — New plan:** Register a new plan in Plan Matrix and set "Next hand off — Lane A" to its first chunk.
- **Option C — Optional chunk promoted:** Pick an item from "Optional and deferred work" and add it as a formal plan or chunk (e.g. Fastlane + deploy.yml as a small plan).

Until then, Lane A has **no mandatory task**.

---

## 3. Next priority (optional — Lane A)

**Chosen optional chunk:** **Fastlane + deploy.yml enhancements** (from Master-Plan "Optional and deferred work" — Tier 3 optional).

**Reference:** Master-Plan History (6) Tier 3: "Fastlane: already in `ios/fastlane/`; deploy.yml runs tests (not just build)." Optional enhancements were deferred.

**Scope for Lane A (smallest manageable pieces):**

| Piece | Description | Confidence (root) | Note |
|-------|-------------|--------------------|------|
| F1 | Document current state: deploy.yml builds + tests + artifact; Fastfile has placeholder `beta` lane | High | Read-only; no code change |
| F2 | Implement `fastlane beta`: `build_app(scheme: "CatRunner", export_method: "app-store")` and `upload_to_testflight` (or equivalent) using App Store Connect API key or Apple ID secrets | Medium | Requires secrets in CI; optional to do locally first |
| F3 | Wire deploy.yml to run `cd ios && fastlane beta` (or call fastlane from workflow) when secrets are available; keep manual fallback (current behavior) if secrets absent | Medium | Rollback: revert workflow step |
| F4 | Update deploy summary and fastlane README to describe automated vs manual path | High | Docs only |

**Out of scope for this optional chunk:** Second simulator in CI (already done — test-ios-se, test-ios-matrix in test.yml).

**Validation:**

- After F2/F3: deploy workflow still builds and runs tests; if secrets present, TestFlight upload runs; if not, manual path still documented.
- Rollback: revert workflow and/or Fastfile changes; redeploy previous version.

**Risks:**

- App Store Connect API key or Apple ID credentials must be stored in GitHub secrets; not created by this plan.
- If F2/F3 are blocked by credentials, complete F1 + F4 only and document "automation ready when secrets are added."

**Confidence:**

- **High** that F1 and F4 are safe and useful.
- **Medium** that F2/F3 can be implemented without credential access (implementation can stub or document required secrets).

---

## 4. Hand off to Lane A

- **Mandatory:** None.
- **Optional (Lane A):** Execute optional chunk **Fastlane + deploy.yml enhancements** (pieces F1–F4, or F1+F4 if F2/F3 blocked). Use **generalPurpose** agent for implementation.
- **Master-Plan:** Update "Next hand off — Lane A" to: Tier 5 committed and pushed; next priority set by planner (this document); Lane A optional = Fastlane + deploy.yml enhancements; planner done; Lane A (generalPurpose) for chosen chunk.

---

## 5. References

- [Master-Plan.md](.cursor/Plans/Master-Plan.md) — Next hand off, Optional and deferred work, History (6) Tier 3
- [deploy.yml](.github/workflows/deploy.yml) — current build + test + artifact
- [ios/fastlane/Fastfile](ios/fastlane/Fastfile) — placeholder `beta` lane
- [ios/fastlane/README.md](ios/fastlane/README.md) — manual TestFlight instructions
