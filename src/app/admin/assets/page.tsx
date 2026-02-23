'use client';

import { useEffect, useState } from 'react';

type FlatAssets = Record<string, string>;

export default function AssetUploadPage() {
  const [assets, setAssets] = useState<FlatAssets>({});
  const [loading, setLoading] = useState(true);
  const [uploading, setUploading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [message, setMessage] = useState<string | null>(null);
  const [selectedKey, setSelectedKey] = useState('');

  useEffect(() => {
    fetch('/api/admin/assets')
      .then((r) => {
        if (!r.ok) throw new Error(r.statusText);
        return r.json();
      })
      .then((data: Record<string, Record<string, string>>) => {
        const flat: FlatAssets = {};
        for (const [category, value] of Object.entries(data)) {
          if (value && typeof value === 'object') {
            for (const [key, filePath] of Object.entries(value)) {
              if (typeof filePath === 'string') flat[`${category}.${key}`] = filePath;
            }
          }
        }
        setAssets(flat);
        const keys = Object.keys(flat);
        if (keys.length) setSelectedKey((prev) => prev || keys[0]);
        setError(null);
      })
      .catch((e) => setError(e instanceof Error ? e.message : 'Failed to load'))
      .finally(() => setLoading(false));
  }, []);

  const handleSubmit = async (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    const form = e.currentTarget;
    const fileInput = form.querySelector<HTMLInputElement>('input[type="file"]');
    const keySelect = form.querySelector<HTMLSelectElement>('select[name="assetKey"]');
    const file = fileInput?.files?.[0];
    const assetKey = keySelect?.value;
    if (!file || !assetKey) {
      setError('Choose a file and an asset key.');
      return;
    }
    setUploading(true);
    setError(null);
    setMessage(null);
    const fd = new FormData();
    fd.set('file', file);
    fd.set('assetKey', assetKey);
    try {
      const res = await fetch('/api/admin/assets/upload', { method: 'POST', body: fd });
      const data = await res.json().catch(() => ({}));
      if (!res.ok) {
        setError(data.error || res.statusText);
        return;
      }
      setMessage(`Uploaded to ${data.path}`);
      fileInput.value = '';
    } catch (e) {
      setError(e instanceof Error ? e.message : 'Upload failed');
    } finally {
      setUploading(false);
    }
  };

  if (loading) {
    return <p className="text-stone-600">Loading assets config…</p>;
  }

  const keys = Object.keys(assets);
  return (
    <div>
      <h1 className="text-2xl font-bold text-stone-800">Asset upload</h1>
      <p className="mt-1 text-sm text-stone-500">
        Upload into paths from <code className="rounded bg-stone-300 px-1">config/default/assets.json</code>.
        Use an existing key; path mapping updates only when adding new keys (not in this UI).
      </p>
      {error && (
        <div className="mt-4 rounded border border-red-300 bg-red-50 p-3 text-red-800">
          {error}
        </div>
      )}
      {message && (
        <div className="mt-4 rounded border border-green-300 bg-green-50 p-3 text-green-800">
          {message}
        </div>
      )}
      <form onSubmit={handleSubmit} className="mt-6 space-y-4">
        <div>
          <label htmlFor="assetKey" className="block text-sm font-medium text-stone-700">
            Asset key
          </label>
          <select
            id="assetKey"
            name="assetKey"
            value={selectedKey}
            onChange={(e) => setSelectedKey(e.target.value)}
            className="mt-1 block w-full max-w-md rounded border border-stone-400 bg-white px-3 py-2 text-stone-800"
          >
            {keys.map((k) => (
              <option key={k} value={k}>
                {k} → {assets[k]}
              </option>
            ))}
          </select>
        </div>
        <div>
          <label htmlFor="file" className="block text-sm font-medium text-stone-700">
            File
          </label>
          <input
            id="file"
            name="file"
            type="file"
            className="mt-1 block w-full max-w-md text-sm text-stone-600 file:mr-4 file:rounded file:border-0 file:bg-stone-600 file:px-4 file:py-2 file:text-white file:hover:bg-stone-700"
          />
        </div>
        <button
          type="submit"
          disabled={uploading || keys.length === 0}
          className="rounded bg-stone-700 px-4 py-2 text-white hover:bg-stone-800 disabled:opacity-50"
        >
          {uploading ? 'Uploading…' : 'Upload'}
        </button>
      </form>
      {keys.length > 0 && (
        <div className="mt-8">
          <h2 className="text-lg font-medium text-stone-800">Path map</h2>
          <ul className="mt-2 list-inside list-disc text-sm text-stone-600">
            {keys.map((k) => (
              <li key={k}>
                <code className="rounded bg-stone-300 px-1">{k}</code> → {assets[k]}
              </li>
            ))}
          </ul>
        </div>
      )}
    </div>
  );
}
