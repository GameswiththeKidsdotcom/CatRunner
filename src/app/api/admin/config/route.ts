import { NextResponse } from 'next/server';
import fs from 'fs';
import path from 'path';
import Ajv from 'ajv';
import { loadAdminConfig, resolveAdminPaths } from '@/src/lib/admin-config';

const ajv = new Ajv({ strict: false });

export async function GET() {
  try {
    const config = loadAdminConfig();
    const paths = resolveAdminPaths(config);
    const raw = fs.readFileSync(paths.defaultVariantPath, 'utf-8');
    const data = JSON.parse(raw);
    const schemaRaw = fs.readFileSync(paths.schemaPath, 'utf-8');
    const schema = JSON.parse(schemaRaw);
    const validate = ajv.compile(schema);
    const valid = validate(data);
    return NextResponse.json({
      config: data,
      validation: valid ? { valid: true } : { valid: false, errors: validate.errors },
    });
  } catch (err) {
    const message = err instanceof Error ? err.message : 'Failed to load config';
    return NextResponse.json({ error: message }, { status: 500 });
  }
}

export async function PUT(request: Request) {
  try {
    const config = loadAdminConfig();
    const paths = resolveAdminPaths(config);
    const body = await request.json();

    const schemaRaw = fs.readFileSync(paths.schemaPath, 'utf-8');
    const schema = JSON.parse(schemaRaw);
    const validate = ajv.compile(schema);
    const valid = validate(body);
    if (!valid) {
      return NextResponse.json(
        { error: 'Validation failed', details: validate.errors },
        { status: 400 }
      );
    }

    const dir = path.dirname(paths.defaultVariantPath);
    if (!fs.existsSync(dir)) {
      fs.mkdirSync(dir, { recursive: true });
    }
    fs.writeFileSync(
      paths.defaultVariantPath,
      JSON.stringify(body, null, 2),
      'utf-8'
    );
    return NextResponse.json({ ok: true });
  } catch (err) {
    const message = err instanceof Error ? err.message : 'Failed to save config';
    return NextResponse.json({ error: message }, { status: 500 });
  }
}
