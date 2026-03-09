#!/usr/bin/env python3
"""
Add transparency to cat animation frame PNGs.

The AI-generated frames (cat_jump_1..8.png, cat_slide_1..8.png) are RGB-only
with opaque gray backgrounds. This script converts them to RGBA and sets
alpha=0 for pixels matching the background (detected from corners).

Usage:
  python3 scripts/add-transparency-to-cat-frames.py
  python3 scripts/add-transparency-to-cat-frames.py --dry-run  # preview only
"""

import argparse
import glob
import os
import sys

try:
    from PIL import Image
except ImportError:
    print("Error: Pillow required. Install with: pip install Pillow", file=sys.stderr)
    sys.exit(1)


def get_background_color(img: Image.Image) -> tuple[int, int, int]:
    """Sample corner pixels and return average as background color."""
    w, h = img.size
    corners = [(0, 0), (w - 1, 0), (0, h - 1), (w - 1, h - 1)]
    pixels = [img.getpixel(c) for c in corners]
    # Handle RGB vs RGBA
    r = sum(p[0] for p in pixels) // 4
    g = sum(p[1] for p in pixels) // 4
    b = sum(p[2] for p in pixels) // 4
    return (r, g, b)


def pixel_matches_bg(pixel: tuple, bg: tuple[int, int, int], tolerance: int) -> bool:
    """True if pixel is within tolerance of background color."""
    if len(pixel) >= 3:
        r, g, b = pixel[0], pixel[1], pixel[2]
    else:
        return False
    return (
        abs(r - bg[0]) <= tolerance
        and abs(g - bg[1]) <= tolerance
        and abs(b - bg[2]) <= tolerance
    )


def add_transparency(path: str, tolerance: int = 25, dry_run: bool = False) -> bool:
    """Convert image to RGBA and make background transparent. Returns True if changed."""
    img = Image.open(path)
    if img.mode == "RGBA":
        # Already has alpha; check if background is already transparent
        bg = get_background_color(img)
        corner = img.getpixel((0, 0))
        if len(corner) >= 4 and corner[3] == 0:
            return False  # Already transparent
    img = img.convert("RGB")
    bg = get_background_color(img)
    rgba = img.convert("RGBA")
    data = rgba.load()
    w, h = rgba.size
    changed = False
    for y in range(h):
        for x in range(w):
            p = data[x, y]
            if pixel_matches_bg(p, bg, tolerance):
                if p[3] != 0:
                    changed = True
                data[x, y] = (p[0], p[1], p[2], 0)
    if changed and not dry_run:
        rgba.save(path, "PNG")
    return changed


def main() -> int:
    parser = argparse.ArgumentParser(description="Add transparency to cat animation frames")
    parser.add_argument("--dry-run", action="store_true", help="Preview only, do not write")
    parser.add_argument("--tolerance", type=int, default=25, help="Color match tolerance (default 25)")
    parser.add_argument("--assets-dir", default="assets/character", help="Path to character assets")
    args = parser.parse_args()

    script_dir = os.path.dirname(os.path.abspath(__file__))
    repo_root = os.path.dirname(script_dir)
    assets_dir = os.path.join(repo_root, args.assets_dir)
    if not os.path.isdir(assets_dir):
        print(f"Error: assets dir not found: {assets_dir}", file=sys.stderr)
        return 1

    single_files = ["cat_run.png", "cat_jump.png", "cat_slide.png"]
    files = [os.path.join(assets_dir, f) for f in single_files if os.path.exists(os.path.join(assets_dir, f))]
    patterns = [
        os.path.join(assets_dir, "cat_jump_*.png"),
        os.path.join(assets_dir, "cat_slide_*.png"),
    ]
    for p in patterns:
        files.extend(sorted(glob.glob(p)))
    files = sorted(set(files))  # dedupe if cat_jump.png matches glob (it does not)

    if not files:
        print("No cat character PNG files found", file=sys.stderr)
        return 1

    print(f"Processing {len(files)} files (tolerance={args.tolerance})...")
    for path in files:
        name = os.path.basename(path)
        try:
            changed = add_transparency(path, tolerance=args.tolerance, dry_run=args.dry_run)
            status = "would update" if args.dry_run and changed else ("updated" if changed else "skipped")
            print(f"  {name}: {status}")
        except Exception as e:
            print(f"  {name}: ERROR {e}", file=sys.stderr)
            return 1

    if args.dry_run:
        print("(Dry run - no files written)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
