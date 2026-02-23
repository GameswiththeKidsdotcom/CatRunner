'use client';

import { useEffect, useState } from 'react';

type VariantEntry = { id: string; path: string; isDefault: boolean };

export default function VariantListPage() {
  const [variants, setVariants] = useState<VariantEntry[]>([]);
  const [ciTrigger, setCiTrigger] = useState('');
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    fetch('/api/admin/variants')
      .then((r) => {
        if (!r.ok) throw new Error(r.statusText);
        return r.json();
      })
      .then((data: { variants: VariantEntry[]; ciTrigger: string }) => {
        setVariants(data.variants);
        setCiTrigger(data.ciTrigger || '');
        setError(null);
      })
      .catch((e) => setError(e instanceof Error ? e.message : 'Failed to load'))
      .finally(() => setLoading(false));
  }, []);

  if (loading) {
    return <p className="text-stone-600">Loading variants…</p>;
  }

  if (error) {
    return (
      <div className="rounded border border-red-300 bg-red-50 p-3 text-red-800">
        {error}
      </div>
    );
  }

  return (
    <div>
      <h1 className="text-2xl font-bold text-stone-800">Variant list</h1>
      <p className="mt-1 text-sm text-stone-500">
        Default + <code className="rounded bg-stone-300 px-1">config/variants/*</code>.
        Active variant is determined by the app at runtime.
      </p>
      <ul className="mt-6 space-y-2">
        {variants.map((v) => (
          <li
            key={v.id}
            className="flex items-center gap-3 rounded border border-stone-300 bg-white px-4 py-3"
          >
            <span className="font-medium text-stone-800">{v.id}</span>
            {v.isDefault && (
              <span className="rounded bg-amber-100 px-2 py-0.5 text-xs text-amber-800">
                default
              </span>
            )}
            <code className="text-sm text-stone-500">{v.path}</code>
          </li>
        ))}
      </ul>
      {ciTrigger && (
        <p className="mt-6 text-sm text-stone-500">
          CI: {ciTrigger}
        </p>
      )}
    </div>
  );
}
