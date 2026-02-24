# Fastlane (C10) — CatRunner TestFlight

The `beta` lane builds an IPA and, when App Store Connect API key is set, uploads to TestFlight. Otherwise it only builds; you upload manually.

## Automated vs manual path

| Path | When | What happens |
|------|------|----------------|
| **Automated** | GitHub secrets are set (see below) and Deploy workflow runs | `.github/workflows/deploy.yml` runs tests, then `cd ios && fastlane beta`. Fastlane builds the IPA and uploads to TestFlight. No artifact download needed. |
| **Manual** | Secrets not set, or you run fastlane locally without API key | Deploy workflow: builds archive, uploads `CatRunner-archive` artifact. You download the artifact, export IPA (Xcode Organizer or `xcodebuild -exportArchive`), then upload to App Store Connect. Or run `cd ios && fastlane beta` locally: IPA is at `ios/build/CatRunner.ipa`; upload it manually. |

## Running locally

1. Install fastlane: `brew install fastlane` or `gem install fastlane`.
2. From repo root: `cd ios && fastlane beta`.
3. If API key env vars are set (see below), the build is uploaded to TestFlight. If not, the IPA is at `ios/build/CatRunner.ipa` — upload via Xcode Organizer or `xcrun altool --upload-app`.

## Required secrets (for automation)

To enable **automated** TestFlight upload in CI (and when running `fastlane beta` locally), set:

| Secret / env | Description |
|--------------|-------------|
| `APP_STORE_CONNECT_KEY_ID` | App Store Connect API Key ID (from App Store Connect → Users and Access → Integrations → Keys). |
| `APP_STORE_CONNECT_ISSUER_ID` | App Store Connect Issuer ID (same page). |
| `APP_STORE_CONNECT_KEY_CONTENT` **or** `APP_STORE_CONNECT_KEY_PATH` | The `.p8` key file: either the **raw file content** (e.g. GitHub secret) or a **path** to the `.p8` file (e.g. after writing a secret to a temp file in CI). |

**GitHub Actions:** Add these as repository secrets: `APP_STORE_CONNECT_KEY_ID`, `APP_STORE_CONNECT_ISSUER_ID`, and either `APP_STORE_CONNECT_KEY_CONTENT` (entire .p8 file content) or `APP_STORE_CONNECT_KEY_PATH` (path to .p8; e.g. from a step that writes the key to a file). Then the Deploy workflow will run `fastlane beta` and upload to TestFlight when these are present.

**Local:** Export the same env vars (or put the key path/content in your environment) before running `fastlane beta`.

See [fastlane App Store Connect API](https://docs.fastlane.tools/app-store-connect-api/) and [upload_to_testflight](https://docs.fastlane.tools/actions/upload_to_testflight/).

## Deploy workflow summary

- **Deploy workflow** (`.github/workflows/deploy.yml`): runs on `workflow_dispatch` or push of tags `v*`. Always runs tests first. If the API key secrets are set, it runs `fastlane beta` (build + TestFlight upload). If not, it builds the archive and uploads it as the `CatRunner-archive` artifact for manual upload. See `.github/DEPLOY.md` for the full deploy and TestFlight description.
