import { NextResponse } from 'next/server';
import fs from 'fs';
import path from 'path';
import { loadAdminConfig, resolveAdminPaths } from '@/src/lib/admin-config';

export type VariantEntry = { id: string; path: string; isDefault: boolean };

export async function GET() {
  try {
    const config = loadAdminConfig();
    const paths = resolveAdminPaths(config);
    const list: VariantEntry[] = [];

    list.push({
      id: 'default',
      path: config.defaultVariantPath,
      isDefault: true,
    });

    if (fs.existsSync(paths.variantsDir)) {
      const files = fs.readdirSync(paths.variantsDir);
      for (const f of files) {
        if (f.endsWith('.json')) {
          const name = f.replace(/\.json$/, '');
          list.push({
            id: name,
            path: path.join(config.variantsDir, f),
            isDefault: false,
          });
        }
      }
    }

    return NextResponse.json({ variants: list, ciTrigger: config.ciTrigger });
  } catch (err) {
    const message = err instanceof Error ? err.message : 'Failed to list variants';
    return NextResponse.json({ error: message }, { status: 500 });
  }
}
