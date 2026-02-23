# C10 — Deploy and TestFlight

- **Build / Test:** `.github/workflows/build.yml` and `test.yml` run on push/PR to `main`.
- **Deploy:** `.github/workflows/deploy.yml` runs on `workflow_dispatch` or push of tags `v*`. It builds an archive and uploads it as an artifact.
- **TestFlight:** Manual. Download the `CatRunner-archive` artifact, open in Xcode Organizer (or use `xcodebuild -exportArchive`), export for App Store distribution, then upload to App Store Connect.
- **Future:** To automate, add fastlane lanes in `ios/fastlane/` and call them from `deploy.yml`; see `ios/fastlane/README.md`.
