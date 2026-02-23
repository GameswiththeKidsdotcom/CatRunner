# C10 — CI/CD Workflows

**Next hand off:** Same as Master-Plan Lane A — implement C11 (Automated tests) per [C11-tests.plan.md](C11-tests.plan.md).

---

## Goal

GitHub Actions: build iOS project, run tests, deploy to TestFlight; build report (FPS, memory).

## Steps

1. Add `.github/workflows/build.yml`: checkout; install Xcode; run `xcodebuild -scheme CatRunner -destination 'generic/platform=iOS' build`. Config pulled from repo (`config/default/`).
2. Add `.github/workflows/test.yml` (or combine with build): `xcodebuild test`; unit, simulation, regression, performance tests.
3. Add `.github/workflows/deploy.yml`: build + test; deploy to TestFlight via fastlane or Xcode Cloud (document choice).
4. Build report: log FPS, memory, test duration to workflow summary or artifact (instrumentation in C11).

## Validation

- Workflows run on push/PR; build succeeds; tests pass.
- Deploy workflow reaches TestFlight (or documented manual step).

## Rollback

- Disable workflows; build locally only.

## Confidence

- **Confidence (root cause):** N/A
- **Confidence (solution path):** N/A
