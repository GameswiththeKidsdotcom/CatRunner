# C9 — Admin Panel Scaffold

**Next hand off:** Implement C9 Next.js routes (config/ and assets/ ready per Lane B).

---

## Goal

Next.js admin: config editor for variant.json, asset upload UI, variant list, CI trigger link. In-repo storage (no backend DB).

## Lane B (config/ and assets/ only) — Done

- **config/admin.json** — Manifest for admin panel: `defaultVariantPath`, `schemaPath`, `assetsPath`, `variantsDir`, `ciTrigger`. Admin app should read this for paths and CI doc.
- **config/variants/** — Directory for optional variant overrides; variant list = default + variants/*.
- **assets/** — All path targets from `config/default/assets.json` scaffolded: character/, dogs/, backgrounds/, powerups/, ui/ (obstacles/ already existed). Asset upload can write into these paths.

## Steps (remaining: Next.js / src — other lane)

1. Add admin routes under `src/app/admin/` (or repurpose root Next.js). Read paths from `config/admin.json`.
2. Config editor: page/component to edit `config/default/variant.json` (form or JSON editor); validate with `config/schema.json`; save = document "commit to repo" or local file write for dev.
3. Asset upload: page to upload files into paths defined in `config/default/assets.json` (asset inventory and path map: [sprites-ui-assets.plan.md](sprites-ui-assets.plan.md)). Allow updating path mapping only when adding new asset keys.
4. Variant list: page listing `config/default` and `config/variants/*`; show active variant.
5. CI trigger: link to GitHub Actions workflow (e.g. workflow_dispatch) or docs for manual `git push`.

## Validation

- Config editor loads and validates variant.json.
- Asset upload places files in correct `assets/` paths.

## Rollback

- Remove `src/app/admin/` routes.

## Confidence

- **Confidence (root cause):** N/A
- **Confidence (solution path):** N/A
