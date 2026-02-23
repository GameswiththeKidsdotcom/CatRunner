# Baselines — Test counts and CI

Test baseline and CI: what “pass” means, test counts for regression, and (optional) screenshot/viewport baseline strategy.

## Spec (testing requirements)

- [docs/SPECIFICATION.md](../../../SPECIFICATION.md) §7 — Testing requirements, baseline pass count for CI and regression comparison.

## CI workflow

- [.github/workflows/test.yml](../../../.github/workflows/test.yml) — Runs `xcodebuild test` (CatRunnerTests + CatRunnerUITests); Admin E2E job `admin-e2e` (Playwright).

## Logs and reports

- **Local logs:** iOS and other test run logs live in `logs/` at repo root (gitignored). Direct script or manual run output there to keep root clean.
- **Test reports:** Playwright HTML report and test artifacts go to `reports/` (`reports/playwright-report/`, `reports/test-results/`). Also gitignored.
- **CI:** iOS job still writes `ios/test-output.log` and uploads it as artifact. Admin E2E job uploads `reports/playwright-report/` when Playwright tests fail.

## Screenshot / viewport baselines

When plans define screenshot or viewport baselines (e.g. 5-iPhone matrix, game-over/revive screens), those are documented in the relevant plan under [.cursor/Plans/subplans/P001/](../../../.cursor/Plans/subplans/P001/) or [.cursor/Plans/z-archives/](../../../.cursor/Plans/z-archives/) (e.g. P002 viewport validation, BG4 validation).
