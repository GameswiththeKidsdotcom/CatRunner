# P001 Admin E2E — Ui-Test Plan (Playwright J6–J9)

Per [e2e-spec-journeys.plan.md](e2e-spec-journeys.plan.md) §6.2 and Investigation 4. **ui-test** scope: Admin panel only (Next.js). Use Playwright; viewport per Investigation 4 deliverable (qualitative, fast). Lane A may edit ios/ only; Admin E2E implementation (this plan) may be done by any lane or agent that can edit repo root / `src/` / `e2e/`.

---

## Viewport matrix (Investigation 4)

- **Admin (desktop):** 1280×720 or 1440×900 (one size for PR; second optional for nightly).
- **Override:** Do not apply full "newest 3" matrix; keep harness qualitative and fast.

---

## Journeys and user-usable objects

| Journey | Entry | Steps | Success criteria | Selectors / notes |
|---------|--------|------|-------------------|-------------------|
| **J6** Variant list | GET /admin | 1. Open /admin. 2. Navigate to Variant list (/admin/variants). 3. Assert list shows default + variants. | Links visible; variant list page loads. | `a[href="/admin/variants"]`, then page content (e.g. table or list). |
| **J7** Config editor | GET /admin | 1. Open /admin. 2. Go to Config editor (/admin/config). 3. Wait for config load (GET /api/admin/config). 4. Assert textarea or form has JSON. 5. (Optional) Edit and Save (PUT); assert 200 or save message. | Config loads; validation/save works. | `a[href="/admin/config"]`; editor textarea; Save button; assert "Saved" or no error. |
| **J8** Asset upload | GET /admin | 1. Open /admin. 2. Go to Asset upload (/admin/assets). 3. Assert upload UI (path selector + file input). 4. (Optional) Upload file; assert success or path. | Upload page loads; path + input present. | `a[href="/admin/assets"]`; file input; path dropdown/input. |
| **J9** CI trigger | GET /admin | 1. Open /admin. 2. Go to CI (/admin/ci). 3. Assert CI link or workflow_dispatch doc present; no 404. | CI page loads; link or doc visible. | `a[href="/admin/ci"]`; optional `a[href*="github"]` or text "workflow". |

---

## Implementation checklist

1. **Project:** Add Playwright (or use existing if present). Root or `e2e/` folder; config: one project for Chromium (or single browser) for speed; viewport 1280×720 or 1440×900.
2. **Base URL:** Start Next.js dev server (or use BASE_URL env); navigate to `/admin`.
3. **J6:** Test `/admin` → click Variant list → expect variants list/content.
4. **J7:** Test `/admin` → Config editor → expect config loaded in editor; optional save and assert response.
5. **J8:** Test `/admin` → Asset upload → expect upload form and path selector.
6. **J9:** Test `/admin` → CI → expect CI page content and non-404.
7. **Auth:** No auth in current app; if auth is added later, document E2E login or test user in plan.
8. **Save semantics (J7):** Config API writes to `config/default/variant.json` (file write); no git commit in app. Assert "Saved" or success message per implementation.

---

## Risks and rollback

- **Flaky:** Admin API or Next.js startup; use stable base URL and retries.
- **Rollback:** Disable or skip Admin E2E in CI until stable; no change to ios/.

---

## Reference

- [e2e-spec-journeys.plan.md](e2e-spec-journeys.plan.md) §6.2 (ui-test scope), §2.2 (J6–J9 skeleton).
- [e2e-investigation-findings-2026-02-23.md](e2e-investigation-findings-2026-02-23.md) Investigation 3 (Admin), Investigation 4 (viewport).
- [Agents/ui-test.md](../../../Agents/ui-test.md) — Playwright, viewport, coverage.
