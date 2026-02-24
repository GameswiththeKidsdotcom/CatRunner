# Tier 3 — Scalability for App Store (prioritized roadmap)

**Plan:** Prioritized roadmap (Testing → Defects → App Store → Features). **Lane:** Lane A (ios/, docs/, .github/). No Lane B conflict.

Deliverables:

1. **A7 app icon in AppIcon.appiconset** — done  
2. **Optional fastlane + deploy.yml** — fastlane already present; deploy.yml runs tests  
3. **App Store readiness checklist (doc)** — done  
4. **Optional second simulator in CI** — done  

---

## 1. A7 app icon in AppIcon.appiconset

**Done:** Copied `assets/reference/appIcon_catworld_1024.png` to `ios/CatRunner/Assets.xcassets/AppIcon.appiconset/AppIcon.png`. The reference file was 1376×768; resized to 1024×1024 with `sips -z 1024 1024` so the asset catalog accepts it. Updated `Contents.json` to reference `AppIcon.png` for the 1024×1024 universal iOS slot.

**Validation:** Build with scheme CatRunner; app icon appears in simulator and on device. Asset catalog compiles without errors.

**Rollback:** Remove `AppIcon.png` from AppIcon.appiconset; revert `Contents.json` to template (no filename); restore from git if needed.

---

## 2. Optional fastlane + deploy.yml

**State:** Fastlane already exists in `ios/fastlane/` (Fastfile with placeholder `beta` lane, README). No change required for Tier 3. Deploy workflow updated to **run tests** (not just build) before producing the archive; comment corrected (C11 test target is present).

**Optional future:** Implement `build_app` + `upload_to_testflight` in `beta` lane and call from deploy.yml when App Store Connect API key is configured. See `ios/fastlane/README.md` and [docs/app-store-readiness.md](../../../docs/app-store-readiness.md).

---

## 3. App Store readiness checklist (doc)

**Done:** Created [docs/app-store-readiness.md](../../../docs/app-store-readiness.md). Covers: build and archive (app icon, scheme, archive, tests); TestFlight upload (export, compliance, processing); App Store Connect metadata (when going to store); optional fastlane; CI references.

**Rollback:** Delete doc; no code dependency.

---

## 4. Optional second simulator in CI

**Done:** Added job `test-ios-se` in [.github/workflows/test.yml](../../../.github/workflows/test.yml). Runs same CatRunner scheme tests on **iPhone SE (3rd generation), OS=latest**. Log artifact: `test-output-log-se`. Runs in parallel with main `test` job (iPhone 16).

**Validation:** On push/PR, both `test` and `test-ios-se` run; both must succeed. If SE simulator is unavailable on runner, job will fail and can be made optional (e.g. `continue-on-error`) or removed.

**Rollback:** Remove `test-ios-se` job from test.yml.

---

## Master-Plan hand-off

Tier 3 complete. **Next priority:** Tier 4 (New feature build-out) per prioritized roadmap.
