# App Store readiness checklist (Tier 3)

Use this checklist before submitting to TestFlight or the App Store. CatRunner-specific; adjust for your build and metadata.

## Build and archive

- [ ] **App icon:** `ios/CatRunner/Assets.xcassets/AppIcon.appiconset/` contains a 1024×1024 PNG (e.g. `AppIcon.png`). Source: `assets/reference/appIcon_catworld_1024.png` (A7). If the source is not 1024×1024, resize with `sips -z 1024 1024` or replace with a true 1024×1024 asset.
- [ ] **Scheme:** Build and archive with scheme **CatRunner**, configuration **Release**, destination `generic/platform=iOS`.
- [ ] **Archive:** Produce `CatRunner.xcarchive` (e.g. `xcodebuild -scheme CatRunner -destination 'generic/platform=iOS' -configuration Release -archivePath build/CatRunner.xcarchive archive` from `ios/`).
- [ ] **Tests:** All 65 tests pass (58 CatRunnerTests + 7 CatRunnerUITests) on at least one simulator (e.g. iPhone 16) before archiving.

## TestFlight upload

- [ ] **Export:** Export the archive for **App Store** distribution (Xcode Organizer → Distribute App → App Store Connect).
- [ ] **Upload:** Upload to App Store Connect (Organizer or `xcrun altool --upload-app`).
- [ ] **Export compliance:** If the app uses encryption (e.g. HTTPS only), answer export compliance in App Store Connect (often “No” for standard HTTPS).
- [ ] **Processing:** Wait for build processing; resolve any email issues (missing compliance, invalid icons, etc.).

## App Store Connect metadata (when going to store)

- [ ] **App name / subtitle / description:** Match app behavior; no placeholder text; no competitor names or pricing in description.
- [ ] **Screenshots:** Required sizes (e.g. 6.7" and 5.5") using real app UI; correct device frames.
- [ ] **Privacy:** Privacy policy URL if you collect data; App Privacy form completed.
- [ ] **Age rating / categories:** Set as appropriate for the app.

## Automation (optional)

- [ ] **Fastlane:** `ios/fastlane/` contains a `beta` lane (placeholder). To automate: configure App Store Connect API key (or Apple ID), implement `build_app` + `upload_to_testflight` in the lane, and call `fastlane beta` from `.github/workflows/deploy.yml`. See `ios/fastlane/README.md` and `.github/DEPLOY.md`.

## CI

- [ ] **Deploy workflow:** `.github/workflows/deploy.yml` runs on `workflow_dispatch` or push of tags `v*`; builds archive and uploads artifact for manual TestFlight upload.
- [ ] **Test workflow:** `.github/workflows/test.yml` runs unit + UI tests (and Admin E2E) on push/PR to `main`.

## References

- [Master-Plan](.cursor/Plans/Master-Plan.md) — Prioritized roadmap Tiers 1–4.
- [SPECIFICATION.md](SPECIFICATION.md) — App spec and testing baseline (§7).
- [.github/DEPLOY.md](../.github/DEPLOY.md) — Deploy and TestFlight steps.
