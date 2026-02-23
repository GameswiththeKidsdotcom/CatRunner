# CatWorld A7 — App icon (1024×1024)

**Next hand off:** Execute after A6. When done, mark P001-CatWorld-Assets complete in Master-Plan; set Lane B hand off to next task or “invoke planner when new work added.”

## Goal

Replace app icon placeholder with cat-world icon: cat silhouette on rooftop at night, small neon glow; 1024×1024 PNG, no transparency.

## Steps

1. Build prompt: app icon, cat silhouette on city rooftop at night; small neon glow (pink/amber); soft 2D style; 1024×1024; no transparency; recognizable at small size.
2. Generate and save. Place in `ios/CatRunner/Assets.xcassets/AppIcon.appiconset/` (replace existing placeholder image; Lane B may need to coordinate with Lane A for `ios/` if strict — per Master-Plan, Lane B edits config/ and assets/ only; app icon lives in ios/. So either: (a) save 1024×1024 to `assets/ui/appIcon_source.png` and document that Lane A or user copies to AppIcon.appiconset, or (b) plan allows Lane B to place in ios/ for this single deliverable). Master-Plan says "Lane B may edit config/ and assets/ only" — so icon source should be saved under assets (e.g. `assets/ui/appIcon_catworld.png`) and a note in this plan or A7 that the final step is to copy to AppIcon.appiconset (user or Lane A). Alternatively, the replace-placeholders plan said "ios/.../AppIcon.appiconset" — so we'll state: generate 1024×1024, save to `assets/reference/appIcon_catworld_1024.png` (or assets/ui/), then document that the file must be copied into `ios/CatRunner/Assets.xcassets/AppIcon.appiconset/` (by user or Lane A) to complete. That keeps Lane B out of ios/.
2. Save generated icon to `assets/reference/appIcon_catworld_1024.png` (easy to find).
3. Add to plan and README: Copy `assets/reference/appIcon_catworld_1024.png` into `ios/CatRunner/Assets.xcassets/AppIcon.appiconset/` and name per Xcode (e.g. AppIcon.png or as required by appiconset). Lane A or user performs the copy.

## Paths

- **Generated:** `assets/reference/appIcon_catworld_1024.png`
- **Final use:** `ios/CatRunner/Assets.xcassets/AppIcon.appiconset/` (copy by Lane A or user).

## Validation

- File exists in assets/reference; 1024×1024; cat on rooftop, neon glow; no transparency.

## Rollback

- Remove or replace `assets/reference/appIcon_catworld_1024.png`; restore previous icon in AppIcon.appiconset from git if needed.

## Confidence

- **Confidence (root cause):** N/A
- **Confidence (solution path):** High
