# App Store readiness checklist (Tier 3)

Use this checklist before submitting to TestFlight or the App Store. CatRunner-specific; adjust for your build and metadata.

**Ship readiness (Tier 6):** Baseline and docs are aligned per [Master-Plan](.cursor/Plans/Master-Plan.md) Tier 6: iOS **83 tests** (75 CatRunnerTests + 8 CatRunnerUITests, 2 skipped when monetization not configured); [SPECIFICATION.md](SPECIFICATION.md) §7, [Agents/tester.md](../Agents/tester.md), and this doc use the same numbers.

## Ship it checklist (summary)

Before release, confirm in order:

1. **Baseline green** — All 83 iOS tests pass (or 81 run + 2 skipped) on at least one simulator; `npm run test:full` passes if running admin tests. See [Build and archive](#build-and-archive) below.
2. **Build and archive** — App icon, scheme CatRunner Release, archive produced. See [Build and archive](#build-and-archive).
3. **TestFlight** — Export for App Store, upload to App Store Connect, export compliance, processing. See [TestFlight upload](#testflight-upload).
4. **App Store metadata** — When going to store: name/description, screenshots, privacy, age rating. See [App Store Connect metadata](#app-store-connect-metadata-when-going-to-store).

## Build and archive

- [ ] **App icon:** `ios/CatRunner/Assets.xcassets/AppIcon.appiconset/` contains a 1024×1024 PNG (e.g. `AppIcon.png`). Source: `assets/reference/appIcon_catworld_1024.png` (A7). If the source is not 1024×1024, resize with `sips -z 1024 1024` or replace with a true 1024×1024 asset.
- [ ] **Scheme:** Build and archive with scheme **CatRunner**, configuration **Release**, destination `generic/platform=iOS`.
- [ ] **Archive:** Produce `CatRunner.xcarchive` (e.g. `xcodebuild -scheme CatRunner -destination 'generic/platform=iOS' -configuration Release -archivePath build/CatRunner.xcarchive archive` from `ios/`).
- [ ] **Tests:** All 83 tests pass (75 CatRunnerTests + 8 CatRunnerUITests; 2 skipped when monetization not configured — J4a, J4c) on at least one simulator (e.g. iPhone 16) before archiving.

## Manual simulator testing

To ensure every run in the simulator uses the **latest built** version (and avoid testing stale builds or reporting bugs that are already fixed):

- **Preferred:** In **Xcode**, use **Run** (⌘R). That builds and installs to the selected simulator, then launches — so the run is always the latest build.
- **Optional clean rebuild:** Product → Clean Build Folder (⇧⌘K), then Run (⌘R).
- **Do not:** Rely on launching CatRunner by tapping its icon on the Simulator home screen **unless** you have just run from Xcode (or run the run-simulator script). That icon is the last installed build.
- **Alternatively,** run `npm run ios:simulator` from repo root to build, install, and launch on the booted simulator (see `ios/run-simulator.sh`).

## TestFlight upload

- [ ] **Export:** Export the archive for **App Store** distribution (Xcode Organizer → Distribute App → App Store Connect).
- [ ] **Upload:** Upload to App Store Connect (Organizer or `xcrun altool --upload-app`).
- [ ] **Export compliance:** If the app uses encryption (e.g. HTTPS only), answer export compliance in App Store Connect (often “No” for standard HTTPS).
- [ ] **Processing:** Wait for build processing; resolve any email issues (missing compliance, invalid icons, etc.).

## App Store Connect metadata (when going to store)

- [ ] **App name / subtitle / description:** Match app behavior; no placeholder text; no competitor names or pricing in description.
- [ ] **Screenshots:** Required sizes and capture method (simulator or manual) per [app-store-screenshots.md](app-store-screenshots.md). Provide at least one iPhone size (e.g. 6.9" 1320×2868 portrait); 1–10 screens per size, real app UI only.
- [ ] **Privacy:** Privacy policy URL if you collect data; App Privacy form completed.
- [ ] **Age rating / categories:** Set as appropriate for the app.

## Automation (optional)

- [x] **Fastlane:** `ios/fastlane/` has a `beta` lane: `build_app(scheme: "CatRunner", export_method: "app-store")` and `upload_to_testflight` when App Store Connect API key env vars are set. Deploy workflow runs `fastlane beta` when GitHub secrets are present; otherwise builds archive and uploads artifact. See `ios/fastlane/README.md` and `.github/DEPLOY.md`. Add secrets `APP_STORE_CONNECT_KEY_ID`, `APP_STORE_CONNECT_ISSUER_ID`, and `APP_STORE_CONNECT_KEY_CONTENT` to enable automated TestFlight in CI.

## CI

- [ ] **Deploy workflow:** `.github/workflows/deploy.yml` runs on `workflow_dispatch` or push of tags `v*`; builds archive and uploads artifact for manual TestFlight upload.
- [ ] **Test workflow:** `.github/workflows/test.yml` runs unit + UI tests (and Admin E2E) on push/PR to `main`.

## References

- [Master-Plan](.cursor/Plans/Master-Plan.md) — Prioritized roadmap Tiers 1–6; Tier 6 (Ship readiness) aligned baseline and this checklist.
- [SPECIFICATION.md](SPECIFICATION.md) — App spec and testing baseline (§7).
- [.github/DEPLOY.md](../.github/DEPLOY.md) — Deploy and TestFlight steps.
