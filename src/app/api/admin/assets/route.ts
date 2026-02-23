import { NextResponse } from 'next/server';
import fs from 'fs';
import path from 'path';
import { loadAdminConfig, resolveAdminPaths } from '@/src/lib/admin-config';

/** Exclude directory-only paths (e.g. appIcon) from upload targets. */
function isFilePath(p: string): boolean {
  return !p.endsWith('/') && !p.endsWith(path.sep);
}

export async function GET() {
  try {
    const config = loadAdminConfig();
    const paths = resolveAdminPaths(config);
    const raw = fs.readFileSync(paths.assetsPath, 'utf-8');
    const data = JSON.parse(raw) as Record<string, Record<string, string>>;
    const filtered: Record<string, Record<string, string>> = {};
    for (const [category, value] of Object.entries(data)) {
      if (value && typeof value === 'object') {
        const filteredValue: Record<string, string> = {};
        for (const [k, v] of Object.entries(value)) {
          if (typeof v === 'string' && isFilePath(v)) filteredValue[k] = v;
        }
        if (Object.keys(filteredValue).length) filtered[category] = filteredValue;
      }
    }
    return NextResponse.json(Object.keys(filtered).length ? filtered : data);
  } catch (err) {
    const message = err instanceof Error ? err.message : 'Failed to load assets config';
    return NextResponse.json({ error: message }, { status: 500 });
  }
}
