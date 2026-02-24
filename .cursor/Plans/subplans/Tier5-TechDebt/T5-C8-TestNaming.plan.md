---
name: T5-C8 — Test file naming convention
plan_id: T5-C8-TestNaming
parent: Tier5-TechDebt-Consolidation.plan.md
overview: "Standardize test file naming across the project: use .spec for all test files (Vitest unit + Playwright E2E). Rename the single Vitest unit test file from .test to .spec; document convention."
todos: []
isProject: false
---

# T5-C8 — Test file naming convention

**Status:** Implemented 2026-02-24 (Lane A).

## Goal

- One consistent naming convention for test files across the repo.
- **Convention:** Use the `.spec` suffix for all test files: `*.spec.ts` or `*.spec.tsx`.
- **Scope:** Vitest (unit) and Playwright (E2E). iOS tests (XCTest) are not renamed; they use `*Tests.swift` per Apple convention.

## Current state (pre-T5-C8)

| Location | File | Runner | Suffix |
|----------|------|--------|--------|
| src/app/ | page.test.tsx | Vitest | .test |
| e2e/admin/ | journeys.spec.ts | Playwright | .spec |

## Implementation

1. **Rename** `src/app/page.test.tsx` → `src/app/page.spec.tsx`. No content change.
2. **Config:** No config change required. Vitest default `include` matches both `**/*.test.*` and `**/*.spec.*`. Playwright `testDir: './e2e'` and default match both `.spec` and `.test`.
3. **Documentation:** This plan and the Tier 5 consolidation plan record the convention. Optional: add one line to a testing doc or README that "test files use the `.spec` suffix (unit and E2E)."

## Validation

- `npm run test:full` (Vitest) passes and still discovers `src/app/page.spec.tsx`.
- `npm run test:e2e` (Playwright) unchanged; `e2e/admin/journeys.spec.ts` already `.spec`.
- No references to `page.test.tsx` in codebase (imports use module path, not filename).

## Rollback

Revert the rename: `page.spec.tsx` → `page.test.tsx`. No other files depend on the filename.

## Confidence

- **Root cause / scope:** 95% — only one unit test file used `.test`; E2E already `.spec`.
- **Solution:** 90% — single rename; both runners support `.spec` by default.
