# Fastlane (placeholder for C10)

**Current choice:** Manual TestFlight upload. The deploy workflow builds the app and uploads the `.xcarchive` as an artifact; use Xcode Organizer or `xcodebuild -exportArchive` to export an IPA and upload to App Store Connect.

**To automate TestFlight later:**

1. Install fastlane: `brew install fastlane` or `gem install fastlane`.
2. Run from repo root: `cd ios && fastlane beta` (or add a lane and call it from `.github/workflows/deploy.yml`).
3. Configure App Store Connect API key or Apple ID in environment / secrets; add `fastlane beta` step to the deploy workflow.

See [fastlane docs](https://docs.fastlane.tools/) for `match`, `gym`, and `pilot`.
