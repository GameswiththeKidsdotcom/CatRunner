import Link from 'next/link';

export default function AdminLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <div className="min-h-screen bg-stone-100">
      <header className="border-b border-stone-300 bg-stone-200 px-6 py-4">
        <div className="mx-auto flex max-w-4xl items-center justify-between">
          <Link href="/admin" className="text-xl font-semibold text-stone-800">
            CatRunner Admin
          </Link>
          <nav className="flex gap-4 text-sm">
            <Link
              href="/admin"
              className="text-stone-600 hover:text-stone-900"
            >
              Dashboard
            </Link>
            <Link
              href="/admin/config"
              className="text-stone-600 hover:text-stone-900"
            >
              Config
            </Link>
            <Link
              href="/admin/assets"
              className="text-stone-600 hover:text-stone-900"
            >
              Assets
            </Link>
            <Link
              href="/admin/variants"
              className="text-stone-600 hover:text-stone-900"
            >
              Variants
            </Link>
            <Link
              href="/admin/ci"
              className="text-stone-600 hover:text-stone-900"
            >
              CI
            </Link>
          </nav>
        </div>
      </header>
      <main className="mx-auto max-w-4xl px-6 py-8">{children}</main>
    </div>
  );
}
