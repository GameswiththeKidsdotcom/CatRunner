# C10 — Deploy and TestFlight

## Current state (deploy workflow and fastlane)

- **deploy.yml:** Runs tests first (same as test.yml). Then:
  - **If App Store Connect API key secrets are set** (`APP_STORE_CONNECT_KEY_ID`, `APP_STORE_CONNECT_ISSUER_ID`, and key content or path): runs `fastlane beta` in `ios/`, which builds the IPA and uploads to TestFlight (automated path).
  - **If not:** builds the archive (`xcodebuild -scheme CatRunner ... archive`), writes deploy summary, and uploads `CatRunner-archive` plus logs as artifacts (manual path — download artifact, export IPA, upload via Xcode Organizer or `altool`).
- **Fastfile:** `ios/fastlane/Fastfile` has a `beta` lane: `build_app(scheme: "CatRunner", export_method: "app-store")` and, when API key env vars are set, `upload_to_testflight`. Otherwise it only builds; see `ios/fastlane/README.md` for required secrets.

## Automated vs manual path

| Path | When | What to do |
|------|------|------------|
| **Automated** | GitHub secrets `APP_STORE_CONNECT_KEY_ID`, `APP_STORE_CONNECT_ISSUER_ID`, and key content/path are set | Workflow runs `fastlane beta`; build is uploaded to TestFlight. Check App Store Connect for processing. |
| **Manual** | Secrets not set | Workflow uploads `CatRunner-archive` artifact. Download it, export for App Store distribution (Xcode Organizer or `xcodebuild -exportArchive`), then upload to App Store Connect. |

---

- **Build / Test:** `.github/workflows/build.yml` and `test.yml` run on push/PR to `main`.
- **Deploy:** `.github/workflows/deploy.yml` runs on `workflow_dispatch` or push of tags `v*`. With API key secrets: build + TestFlight upload via fastlane. Without: build + artifact for manual upload.
- **TestFlight:** Automated when secrets are set; otherwise manual (download artifact → export IPA → upload). See `ios/fastlane/README.md` for required secrets.
