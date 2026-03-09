import Link from "next/link";

const requests = [
  { id: "REQ-2941", name: "Marcus Johnson", role: "Guide", submitted: "Oct 24, 2023", status: "Pending Review" },
  { id: "REQ-2940", name: "Alan Lee", role: "Guide", submitted: "Oct 22, 2023", status: "Documents Incomplete" },
  { id: "REQ-2938", name: "David Kim", role: "Guide", submitted: "Oct 21, 2023", status: "Pending Review" },
];

export default function VerificationsPage() {
  return (
    <div className="max-w-7xl mx-auto space-y-6">
      <div className="flex items-end justify-between gap-4">
        <div>
          <h1 className="text-2xl font-bold text-gray-900 dark:text-white">Verification Queue</h1>
          <p className="text-gray-500 dark:text-gray-400 mt-1">Review submitted documents and issue verification badges.</p>
        </div>
      </div>

      <div className="bg-white dark:bg-surface-dark rounded-xl border border-gray-200 dark:border-gray-800 overflow-hidden shadow-sm">
        <div className="overflow-x-auto">
          <table className="w-full text-left border-collapse">
            <thead>
              <tr className="bg-gray-50 dark:bg-surface-darker border-b border-gray-200 dark:border-gray-800">
                <th className="py-4 px-6 text-xs font-semibold uppercase tracking-wider text-gray-500 dark:text-gray-400">Applicant</th>
                <th className="py-4 px-6 text-xs font-semibold uppercase tracking-wider text-gray-500 dark:text-gray-400">Role</th>
                <th className="py-4 px-6 text-xs font-semibold uppercase tracking-wider text-gray-500 dark:text-gray-400">Date Submitted</th>
                <th className="py-4 px-6 text-xs font-semibold uppercase tracking-wider text-gray-500 dark:text-gray-400">Status</th>
                <th className="py-4 px-6 text-right text-xs font-semibold uppercase tracking-wider text-gray-500 dark:text-gray-400">Action</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-gray-200 dark:divide-gray-800">
              {requests.map((r) => (
                <tr key={r.id} className="hover:bg-gray-50 dark:hover:bg-surface-darker/50 transition-colors">
                  <td className="py-4 px-6">
                    <div className="flex items-center gap-3">
                      <div className="w-10 h-10 rounded-full bg-primary/20 flex items-center justify-center text-primary font-bold">
                        {r.name.split(" ").map((x) => x[0]).slice(0, 2).join("")}
                      </div>
                      <div>
                        <p className="text-sm font-medium text-gray-900 dark:text-white">{r.name}</p>
                        <p className="text-xs text-gray-500 dark:text-gray-400">ID: #{r.id}</p>
                      </div>
                    </div>
                  </td>
                  <td className="py-4 px-6">
                    <span className="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-purple-100 text-purple-800 dark:bg-purple-900/30 dark:text-purple-300">
                      {r.role}
                    </span>
                  </td>
                  <td className="py-4 px-6 text-sm text-gray-500 dark:text-gray-400">{r.submitted}</td>
                  <td className="py-4 px-6">
                    <div className="flex items-center gap-2">
                      <span className={["w-2 h-2 rounded-full", r.status === "Pending Review" ? "bg-yellow-500 animate-pulse" : "bg-orange-500"].join(" ")} />
                      <span className={["text-sm font-medium", r.status === "Pending Review" ? "text-yellow-600 dark:text-yellow-400" : "text-orange-600 dark:text-orange-400"].join(" ")}>
                        {r.status}
                      </span>
                    </div>
                  </td>
                  <td className="py-4 px-6 text-right">
                    <Link
                      href={`/verifications/${r.id}`}
                      className="inline-flex items-center justify-center px-3 py-2 text-xs font-medium text-primary bg-primary/10 hover:bg-primary hover:text-white rounded-lg transition-colors"
                    >
                      Review
                    </Link>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>

        <div className="px-6 py-4 border-t border-gray-200 dark:border-gray-800 flex items-center justify-between bg-gray-50 dark:bg-surface-darker/30">
          <p className="text-xs text-gray-500 dark:text-gray-400">Showing 4 of 42 pending requests</p>
          <div className="flex gap-2">
            <button className="px-3 py-1 text-xs font-medium text-gray-500 bg-white dark:bg-surface-dark border border-gray-200 dark:border-gray-700 rounded-md disabled:opacity-50" disabled>
              Previous
            </button>
            <button className="px-3 py-1 text-xs font-medium text-gray-500 bg-white dark:bg-surface-dark border border-gray-200 dark:border-gray-700 rounded-md hover:bg-gray-50 dark:hover:bg-gray-800">
              Next
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}
