import Link from 'next/link';

export default function AdminDashboard() {
  return (
    <div>
      <h1 className="text-2xl font-bold text-stone-800">Admin Dashboard</h1>
      <p className="mt-2 text-stone-600">
        Manage variant config, assets, and CI. Paths are read from{' '}
        <code className="rounded bg-stone-300 px-1">config/admin.json</code>.
      </p>
      <ul className="mt-8 grid gap-4 sm:grid-cols-2">
        <li>
          <Link
            href="/admin/config"
            className="block rounded-lg border border-stone-300 bg-white p-4 shadow-sm transition hover:border-stone-400 hover:shadow"
          >
            <span className="font-medium text-stone-800">Config editor</span>
            <span className="mt-1 block text-sm text-stone-500">
              Edit variant.json with schema validation
            </span>
          </Link>
        </li>
        <li>
          <Link
            href="/admin/assets"
            className="block rounded-lg border border-stone-300 bg-white p-4 shadow-sm transition hover:border-stone-400 hover:shadow"
          >
            <span className="font-medium text-stone-800">Asset upload</span>
            <span className="mt-1 block text-sm text-stone-500">
              Upload files into assets/ paths
            </span>
          </Link>
        </li>
        <li>
          <Link
            href="/admin/variants"
            className="block rounded-lg border border-stone-300 bg-white p-4 shadow-sm transition hover:border-stone-400 hover:shadow"
          >
            <span className="font-medium text-stone-800">Variant list</span>
            <span className="mt-1 block text-sm text-stone-500">
              Default and config/variants/*
            </span>
          </Link>
        </li>
        <li>
          <Link
            href="/admin/ci"
            className="block rounded-lg border border-stone-300 bg-white p-4 shadow-sm transition hover:border-stone-400 hover:shadow"
          >
            <span className="font-medium text-stone-800">CI trigger</span>
            <span className="mt-1 block text-sm text-stone-500">
              GitHub Actions workflow_dispatch / push
            </span>
          </Link>
        </li>
      </ul>
    </div>
  );
}
