'use client';

import { useEffect, useState } from 'react';

export default function ConfigEditorPage() {
  const [json, setJson] = useState('');
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [saveMessage, setSaveMessage] = useState<string | null>(null);

  useEffect(() => {
    fetch('/api/admin/config')
      .then((r) => {
        if (!r.ok) throw new Error(r.statusText);
        return r.json();
      })
      .then((data: { config?: unknown; validation?: { valid: boolean; errors?: unknown[] }; error?: string }) => {
        if (data.error) {
          setError(data.error);
          return;
        }
        const config = data.config ?? data;
        const validation = data.validation;
        setJson(JSON.stringify(config, null, 2));
        setError(null);
        if (validation && !validation.valid && validation.errors?.length) {
          setSaveMessage(null);
          setError(`Schema validation failed: ${JSON.stringify(validation.errors)}`);
        }
      })
      .catch((e) => setError(e instanceof Error ? e.message : 'Failed to load'))
      .finally(() => setLoading(false));
  }, []);

  const handleSave = async () => {
    setSaving(true);
    setSaveMessage(null);
    setError(null);
    let parsed: unknown;
    try {
      parsed = JSON.parse(json);
    } catch {
      setError('Invalid JSON');
      setSaving(false);
      return;
    }
    try {
      const res = await fetch('/api/admin/config', {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(parsed),
      });
      const data = await res.json().catch(() => ({}));
      if (!res.ok) {
        const details = data.details ? ` ${JSON.stringify(data.details)}` : '';
        setError((data.error || res.statusText) + details);
        return;
      }
      setSaveMessage('Saved. Commit to repo to persist.');
    } catch (e) {
      setError(e instanceof Error ? e.message : 'Save failed');
    } finally {
      setSaving(false);
    }
  };

  if (loading) {
    return <p className="text-stone-600">Loading variant config…</p>;
  }

  return (
    <div>
      <h1 className="text-2xl font-bold text-stone-800">Config editor</h1>
      <p className="mt-1 text-sm text-stone-500">
        Edits <code className="rounded bg-stone-300 px-1">config/default/variant.json</code>.
        Validated with <code className="rounded bg-stone-300 px-1">config/schema.json</code>.
      </p>
      {error && (
        <div className="mt-4 rounded border border-red-300 bg-red-50 p-3 text-red-800">
          {error}
        </div>
      )}
      {saveMessage && (
        <div className="mt-4 rounded border border-green-300 bg-green-50 p-3 text-green-800">
          {saveMessage}
        </div>
      )}
      <textarea
        className="mt-4 w-full font-mono text-sm leading-relaxed text-stone-800"
        rows={24}
        value={json}
        onChange={(e) => setJson(e.target.value)}
        spellCheck={false}
      />
      <div className="mt-4">
        <button
          type="button"
          onClick={handleSave}
          disabled={saving}
          className="rounded bg-stone-700 px-4 py-2 text-white hover:bg-stone-800 disabled:opacity-50"
        >
          {saving ? 'Saving…' : 'Validate & save'}
        </button>
      </div>
    </div>
  );
}
