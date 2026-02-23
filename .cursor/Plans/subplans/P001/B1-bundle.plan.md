# B1 — Config and assets in app bundle

**Status:** Done. Config and assets are copied into the app bundle via Run Script phase "Copy Config and Assets".

**Next hand off (cut & paste) — Lane A:** Execute [B2-loader.plan.md](B2-loader.plan.md): implement asset loader (assets.json → textures). Validate by loading assets.json from bundle and resolving character.run to a texture. When done, update hand off to B3 (player texture). Lane A may edit ios/ only.

---

## Goal

Place `variant.json`, `assets.json`, and the repo `assets/` directory (or equivalent file set) inside the CatRunner app bundle so the app can load them at runtime. B2 will assume paths like `config/default/assets.json` and `assets/character/cat_run.png` relative to the bundle root.

## Steps

1. Add `config/default/variant.json` and `config/default/assets.json` to the CatRunner target (Copy Bundle Resources). Use a group or folder reference so the path structure is preserved (e.g. `config/default/` in bundle). Paths from repo root: `config/default/variant.json`, `config/default/assets.json`; add a group "config" with "default" and add both JSON files, or add a Run Script phase that copies `$(SRCROOT)/../config/default/*.json` into `$(CONTENTS_FOLDER_PATH)/config/default/`.
2. Add the `assets/` directory (or its contents) to the CatRunner target so that paths like `assets/character/cat_run.png` resolve inside the bundle. Options: (a) Add `assets` as a folder reference (blue folder) in Xcode under the CatRunner group, then add that folder to Copy Bundle Resources; (b) Run Script phase that copies `$(SRCROOT)/../assets` into `$(CONTENTS_FOLDER_PATH)/assets` preserving structure. Document the resulting bundle layout (e.g. `CatRunner.app/config/default/variant.json`, `CatRunner.app/config/default/assets.json`, `CatRunner.app/assets/character/cat_run.png`) for B2.

**Implementation:** Run Script phase "Copy Config and Assets" (PBXShellScriptBuildPhase R1000001) runs after Resources. It copies `$(SRCROOT)/../config/default/*.json` into `$(BUILT_PRODUCTS_DIR)/$(WRAPPER_NAME)/config/default/` and `$(SRCROOT)/../assets` into `$(BUILT_PRODUCTS_DIR)/$(WRAPPER_NAME)/assets/`. Default xcodebuild output is DerivedData; optional `-derivedDataPath ios/build` uses repo-local build.

## Paths

- **Repo:** `config/default/variant.json`, `config/default/assets.json`, `assets/**/*`
- **Bundle (target):** Same relative paths under app bundle root (e.g. `config/default/`, `assets/`).

## Validation

- Build the CatRunner app for simulator or device.
- Inspect the built product (e.g. `ios/build/Build/Products/Debug-iphonesimulator/CatRunner.app` or Xcode DerivedData): confirm `config/default/variant.json`, `config/default/assets.json`, and e.g. `assets/character/cat_run.png` exist with the same relative paths.

**Bundle layout (after B1):** Under `CatRunner.app/`: `config/default/variant.json`, `config/default/assets.json`, `assets/` (e.g. `assets/character/cat_run.png`, `assets/obstacles/*.png`, `assets/dogs/dog.png`, etc.). B2 resolves paths from `Bundle.main` using these relative paths.

## Rollback

- Remove the added resources or Run Script build phase from the CatRunner target. App reverts to current behavior (no config/assets in bundle).

## Confidence

- **Confidence (root cause):** N/A (design).
- **Confidence (solution path):** High.
