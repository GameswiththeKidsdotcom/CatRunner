/**
 * Admin panel config: paths and CI trigger from config/admin.json.
 * Used by API routes and server components; paths are resolved from process.cwd().
 */

import path from 'path';
import fs from 'fs';

export type AdminConfig = {
  defaultVariantPath: string;
  schemaPath: string;
  assetsPath: string;
  variantsDir: string;
  ciTrigger: string;
  /** Optional URL to GitHub Actions (e.g. workflow_dispatch or Actions tab). */
  ciWorkflowUrl?: string;
};

const ADMIN_CONFIG_PATH = 'config/admin.json';

function projectPath(relativePath: string): string {
  return path.join(process.cwd(), relativePath);
}

export function getAdminConfigPath(): string {
  return projectPath(ADMIN_CONFIG_PATH);
}

export function loadAdminConfig(): AdminConfig {
  const fullPath = getAdminConfigPath();
  const raw = fs.readFileSync(fullPath, 'utf-8');
  return JSON.parse(raw) as AdminConfig;
}

export function resolveAdminPaths(config: AdminConfig): {
  defaultVariantPath: string;
  schemaPath: string;
  assetsPath: string;
  variantsDir: string;
} {
  return {
    defaultVariantPath: projectPath(config.defaultVariantPath),
    schemaPath: projectPath(config.schemaPath),
    assetsPath: projectPath(config.assetsPath),
    variantsDir: projectPath(config.variantsDir),
  };
}
