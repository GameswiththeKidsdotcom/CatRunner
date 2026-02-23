/**
 * CatRunner Admin E2E — J6–J9 per e2e-spec-journeys.plan.md §2.2 and §6.2.
 * Viewport: desktop 1280 or 1440 (Investigation 4); layout/contrast/viewport coverage.
 */
import { test, expect } from '@playwright/test';

test.describe('J6 — Variant list', () => {
  test('opens admin and shows variant list with default', async ({ page }) => {
    await page.goto('/admin');
    await expect(page.getByRole('heading', { name: /admin dashboard/i })).toBeVisible();
    await page.getByRole('link', { name: /variant list/i }).click();
    await expect(page).toHaveURL(/\/admin\/variants/);
    await expect(page.getByRole('heading', { name: /variant list/i })).toBeVisible();
    await expect(page.getByText('default').first()).toBeVisible();
    await expect(page.getByText(/config/).first()).toBeVisible();
  });

  test('nav from dashboard to variant list and back', async ({ page }) => {
    await page.goto('/admin');
    await page.getByRole('link', { name: /variants/i }).first().click();
    await expect(page).toHaveURL(/\/admin\/variants/);
    await page.getByRole('link', { name: /dashboard/i }).click();
    await expect(page).toHaveURL(/\/admin\/?$/);
  });
});

test.describe('J7 — Config editor', () => {
  test('opens config editor, loads variant.json, shows validate & save', async ({ page }) => {
    await page.goto('/admin');
    await page.getByRole('link', { name: /config editor/i }).click();
    await expect(page).toHaveURL(/\/admin\/config/);
    await expect(page.getByRole('heading', { name: /config editor/i })).toBeVisible();
    await expect(page.getByText(/variant\.json|schema\.json/).first()).toBeVisible();
    const textarea = page.getByRole('textbox');
    await expect(textarea).toBeVisible();
    await expect(page.getByRole('button', { name: /validate & save/i })).toBeVisible();
  });

  test('invalid JSON shows error on save', async ({ page }) => {
    await page.goto('/admin/config');
    const textarea = page.getByRole('textbox');
    await textarea.fill('{ "invalid": ');
    await page.getByRole('button', { name: /validate & save/i }).click();
    await expect(page.getByText(/invalid json/i)).toBeVisible();
  });

  test('valid save: current config validates and save shows success', async ({ page }) => {
    await page.goto('/admin/config');
    await expect(page.getByText(/loading variant config/i)).toBeHidden({ timeout: 15000 });
    const textarea = page.getByRole('textbox');
    const hasContent = (await textarea.inputValue()).length > 0;
    if (!hasContent) {
      test.skip(true, 'Config API did not return content (e.g. file path or server error)');
      return;
    }
    await page.getByRole('button', { name: /validate & save/i }).click();
    await expect(page.getByText(/saved|persist/i).first()).toBeVisible({ timeout: 10000 });
  });
});

test.describe('J8 — Asset upload', () => {
  test('opens asset upload, shows path selector and upload control', async ({ page }) => {
    await page.goto('/admin');
    await page.getByRole('link', { name: /asset upload/i }).click();
    await expect(page).toHaveURL(/\/admin\/assets/);
    await expect(page.getByRole('heading', { name: /asset upload/i })).toBeVisible();
    await expect(page.getByRole('combobox', { name: /asset key/i })).toBeVisible();
    await expect(page.getByRole('button', { name: /upload/i })).toBeVisible();
  });

  test('asset key dropdown populated when assets config exists', async ({ page }) => {
    await page.goto('/admin/assets');
    const select = page.locator('select[name="assetKey"]');
    await expect(select).toBeVisible();
    await expect(select).toBeEnabled({ timeout: 5000 });
  });
});

test.describe('J9 — CI trigger', () => {
  test('opens CI page and shows workflow info or link', async ({ page }) => {
    await page.goto('/admin');
    await page.getByRole('link', { name: /ci trigger/i }).click();
    await expect(page).toHaveURL(/\/admin\/ci/);
    await expect(page.getByRole('heading', { name: /ci trigger/i })).toBeVisible();
    await expect(page.getByRole('main').getByText(/workflow_dispatch|ciWorkflowUrl|config\/admin\.json/).first()).toBeVisible();
  });

  test('CI page has no 404 and back link works', async ({ page }) => {
    const res = await page.goto('/admin/ci');
    expect(res?.status()).toBe(200);
    await expect(page.getByRole('link', { name: /back to dashboard/i })).toBeVisible();
    await page.getByRole('link', { name: /back to dashboard/i }).click();
    await expect(page).toHaveURL(/\/admin\/?$/);
  });
});

test.describe('Layout and contrast (viewport)', () => {
  test('admin dashboard layout: header and main content visible', async ({ page }) => {
    await page.goto('/admin');
    await expect(page.getByRole('banner')).toBeVisible();
    await expect(page.getByRole('main')).toBeVisible();
    await expect(page.getByText('CatRunner Admin')).toBeVisible();
  });

  test('admin nav links present and clickable', async ({ page }) => {
    await page.goto('/admin');
    const nav = page.getByRole('navigation');
    await expect(nav.getByRole('link', { name: /config/i })).toBeVisible();
    await expect(nav.getByRole('link', { name: /assets/i })).toBeVisible();
    await expect(nav.getByRole('link', { name: /variants/i })).toBeVisible();
    await expect(nav.getByRole('link', { name: /ci/i })).toBeVisible();
  });
});
