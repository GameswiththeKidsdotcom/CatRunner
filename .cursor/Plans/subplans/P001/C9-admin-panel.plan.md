# C9 — Admin Panel Scaffold

**Next hand off:** Same as Master-Plan Lane A. C9 Next.js admin routes are complete. For next task invoke [Agents/planner.md](../../../Agents/planner.md).

---

## Goal

Next.js admin: config editor for variant.json, asset upload UI, variant list, CI trigger link. In-repo storage (no backend DB).

## Lane B (config/ and assets/ only) — Done

- **config/admin.json** — Manifest for admin panel: `defaultVariantPath`, `schemaPath`, `assetsPath`, `variantsDir`, `ciTrigger`, optional `ciWorkflowUrl`. Admin app reads this for paths and CI.
- **config/variants/** — Directory for optional variant overrides; variant list = default + variants/*.
- **assets/** — All path targets from `config/default/assets.json` scaffolded: character/, dogs/, backgrounds/, powerups/, ui/ (obstacles/ already existed). Asset upload writes into these paths.

## Steps — Done

1. **Done.** Admin routes under `src/app/admin/`. Paths from `config/admin.json` via `src/lib/admin-config.ts`.
2. **Done.** Config editor at `/admin/config`: loads `config/default/variant.json`, validates on load and on save with `config/schema.json`; save writes to default variant path.
3. **Done.** Asset upload at `/admin/assets`: uploads into paths from `config/default/assets.json`; directory targets (e.g. appIcon) excluded from dropdown and rejected by API.
4. **Done.** Variant list at `/admin/variants`: default + `config/variants/*`; CI trigger text from admin.json.
5. **Done.** CI trigger at `/admin/ci`: docs and optional `ciWorkflowUrl` link to GitHub Actions.

## Validation

- Config editor loads and validates variant.json.
- Asset upload places files in correct `assets/` paths.

## Rollback

- Remove `src/app/admin/` routes.

## Confidence

- **Confidence (root cause):** N/A
- **Confidence (solution path):** N/A
