import { NextResponse } from 'next/server';
import fs from 'fs';
import path from 'path';
import { loadAdminConfig, resolveAdminPaths } from '@/src/lib/admin-config';

/**
 * Flatten assets.json into { "category.key": "assets/..." }.
 */
function flattenAssets(assets: Record<string, unknown>): Record<string, string> {
  const out: Record<string, string> = {};
  for (const [category, value] of Object.entries(assets)) {
    if (value && typeof value === 'object' && !Array.isArray(value)) {
      for (const [key, filePath] of Object.entries(value)) {
        if (typeof filePath === 'string') {
          out[`${category}.${key}`] = filePath;
        }
      }
    }
  }
  return out;
}

export async function POST(request: Request) {
  try {
    const formData = await request.formData();
    const file = formData.get('file') as File | null;
    const assetKey = formData.get('assetKey') as string | null; // e.g. "character.run"

    if (!file || !assetKey) {
      return NextResponse.json(
        { error: 'Missing file or assetKey (e.g. character.run)' },
        { status: 400 }
      );
    }

    const config = loadAdminConfig();
    const paths = resolveAdminPaths(config);
    const assetsRaw = fs.readFileSync(paths.assetsPath, 'utf-8');
    const assets = JSON.parse(assetsRaw) as Record<string, Record<string, string>>;
    const flat = flattenAssets(assets as unknown as Record<string, unknown>);

    const targetRelative = flat[assetKey];
    if (!targetRelative) {
      return NextResponse.json(
        { error: `Unknown asset key: ${assetKey}. Use an existing key from assets config.` },
        { status: 400 }
      );
    }
    if (targetRelative.endsWith('/') || targetRelative.endsWith(path.sep)) {
      return NextResponse.json(
        { error: 'This asset key points to a directory; upload is for file paths only.' },
        { status: 400 }
      );
    }

    const targetFull = path.join(process.cwd(), targetRelative);
    const dir = path.dirname(targetFull);
    if (!fs.existsSync(dir)) {
      fs.mkdirSync(dir, { recursive: true });
    }

    const bytes = await file.arrayBuffer();
    fs.writeFileSync(targetFull, Buffer.from(bytes));
    return NextResponse.json({ ok: true, path: targetRelative });
  } catch (err) {
    const message = err instanceof Error ? err.message : 'Upload failed';
    return NextResponse.json({ error: message }, { status: 500 });
  }
}
