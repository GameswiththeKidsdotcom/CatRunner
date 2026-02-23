import { loadAdminConfig } from '@/src/lib/admin-config';
import Link from 'next/link';

export default async function CITriggerPage() {
  const config = loadAdminConfig();
  const hasWorkflowUrl = config.ciWorkflowUrl && config.ciWorkflowUrl.trim().length > 0;

  return (
    <div>
      <h1 className="text-2xl font-bold text-stone-800">CI trigger</h1>
      <p className="mt-2 text-stone-600">
        Paths and workflow info are read from <code className="rounded bg-stone-300 px-1">config/admin.json</code>.
      </p>
      <div className="mt-6 rounded border border-stone-300 bg-white p-4">
        <h2 className="font-medium text-stone-800">CI / deploy</h2>
        <p className="mt-2 whitespace-pre-wrap text-sm text-stone-600">
          {config.ciTrigger}
        </p>
        {hasWorkflowUrl && (
          <p className="mt-4">
            <Link
              href={config.ciWorkflowUrl!}
              target="_blank"
              rel="noopener noreferrer"
              className="inline-flex items-center rounded bg-stone-700 px-4 py-2 text-white hover:bg-stone-800"
            >
              Open GitHub Actions →
            </Link>
          </p>
        )}
        <p className="mt-4 text-sm text-stone-500">
          Use <strong>workflow_dispatch</strong> in GitHub Actions to trigger builds manually, or push to <code className="rounded bg-stone-300 px-1">main</code> / tags <code className="rounded bg-stone-300 px-1">v*</code> for automated runs.
          Set <code className="rounded bg-stone-300 px-1">ciWorkflowUrl</code> in <code className="rounded bg-stone-300 px-1">config/admin.json</code> to show a direct link.
        </p>
        <Link
          href="/admin"
          className="mt-4 inline-block text-sm text-stone-600 underline hover:text-stone-800"
        >
          ← Back to dashboard
        </Link>
      </div>
    </div>
  );
}
