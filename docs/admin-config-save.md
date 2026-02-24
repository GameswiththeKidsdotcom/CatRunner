# Admin config save semantics (Tier 2)

This document describes how the admin panel config editor saves variant configuration. It closes the spec/impl gap identified in the prioritized roadmap Tier 2 (Defect remediation).

## API

- **Route:** `src/app/api/admin/config/`
- **GET:** Returns the current default variant JSON plus validation result against the schema.
- **PUT:** Accepts a JSON body; validates against schema; on success, overwrites the default variant file.

## Path resolution

- Paths are defined in **`config/admin.json`**:
  - `defaultVariantPath`: e.g. `config/default/variant.json`
  - `schemaPath`: e.g. `config/schema.json`
- Resolved from **`process.cwd()`** (repo root when running Next.js dev or build).
- Implementation: `src/lib/admin-config.ts` — `loadAdminConfig()`, `resolveAdminPaths()`.

## GET behavior

1. Load `config/admin.json` from project root.
2. Resolve `defaultVariantPath` and `schemaPath` to absolute paths.
3. Read `config/default/variant.json` (or whatever `defaultVariantPath` is) and `config/schema.json`.
4. Parse JSON; validate variant against schema (Ajv).
5. Return `{ config, validation: { valid } | { valid: false, errors } }`. On read error, return 500.

## PUT behavior

1. Load admin config and resolve paths (same as GET).
2. Parse request body as JSON.
3. Validate body against `config/schema.json` (Ajv). If invalid, return 400 with `{ error, details: validate.errors }`.
4. Ensure directory of `defaultVariantPath` exists (`fs.mkdirSync(..., { recursive: true })`).
5. Write body to `defaultVariantPath` with `JSON.stringify(body, null, 2)` (UTF-8). **Overwrites** existing file.
6. Return `{ ok: true }`. On write error, return 500.

## Semantics summary

| Aspect | Behavior |
|--------|----------|
| **Persistence** | Local file overwrite only. No git commit, no push. |
| **Validation** | PUT validates full document against `config/schema.json` before write. |
| **Auth** | None. Admin routes do not enforce authentication. |
| **iOS app** | App bundle is populated at **build time** (Xcode copy phase). Changes saved in admin do not affect a running or already-built app until the next build. |
| **Active variant** | The "default" variant is the file at `defaultVariantPath`. The iOS app loads the variant that was copied into the bundle (from `config/default/` at build). |

## Confidence and validation

- **Confidence (root cause):** High — behavior read from `src/app/api/admin/config/route.ts` and `src/lib/admin-config.ts`.
- **Validation:** E2E admin journeys (J6–J9) assert config editor load/save; see `e2e/admin/journeys.spec.ts`.
