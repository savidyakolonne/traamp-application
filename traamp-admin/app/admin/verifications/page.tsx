"use client";

import Link from "next/link";
import { useEffect, useState } from "react";

type VerificationRequest = {
  verificationId: string;
  uid: string;
  status: string;
  submittedAt?: {
    _seconds?: number;
    _nanoseconds?: number;
  } | string | null;
  guideSnapshot?: {
    firstName?: string;
    lastName?: string;
    email?: string;
    location?: string;
  };
};

export default function VerificationsPage() {
  const [requests, setRequests] = useState<VerificationRequest[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchVerificationRequests = async () => {
      try {
        const res = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/admin/verifications`);
        const data = await res.json();

        if (!res.ok) {
          throw new Error(data.error || "Failed to fetch verification requests");
        }

        setRequests(Array.isArray(data) ? data : []);
      } catch (error) {
        console.error(error);
      } finally {
        setLoading(false);
      }
    };

    fetchVerificationRequests();
  }, []);

  const formatDate = (timestamp: any) => {
    if (!timestamp) return "N/A";

    if (typeof timestamp === "string") {
      return new Date(timestamp).toLocaleDateString();
    }

    if (timestamp?._seconds) {
      return new Date(timestamp._seconds * 1000).toLocaleDateString();
    }

    if (timestamp?.seconds) {
      return new Date(timestamp.seconds * 1000).toLocaleDateString();
    }

    return "N/A";
  };

  return (
    <div className="max-w-7xl mx-auto space-y-6">
      <div className="flex items-end justify-between gap-4">
        <div>
          <h1 className="text-2xl font-bold text-gray-900 dark:text-white">
            Verification Queue
          </h1>
          <p className="text-gray-500 dark:text-gray-400 mt-1">
            Review submitted documents and issue verification badges.
          </p>
        </div>
      </div>

      <div className="bg-white dark:bg-surface-dark rounded-xl border border-gray-200 dark:border-gray-800 overflow-hidden shadow-sm">
        <div className="overflow-x-auto">
          <table className="w-full text-left border-collapse">
            <thead>
              <tr className="bg-gray-50 dark:bg-surface-darker border-b border-gray-200 dark:border-gray-800">
                <th className="py-4 px-6 text-xs font-semibold uppercase tracking-wider text-gray-500 dark:text-gray-400">
                  Applicant
                </th>
                <th className="py-4 px-6 text-xs font-semibold uppercase tracking-wider text-gray-500 dark:text-gray-400">
                  Role
                </th>
                <th className="py-4 px-6 text-xs font-semibold uppercase tracking-wider text-gray-500 dark:text-gray-400">
                  Date Submitted
                </th>
                <th className="py-4 px-6 text-xs font-semibold uppercase tracking-wider text-gray-500 dark:text-gray-400">
                  Status
                </th>
                <th className="py-4 px-6 text-right text-xs font-semibold uppercase tracking-wider text-gray-500 dark:text-gray-400">
                  Action
                </th>
              </tr>
            </thead>

            <tbody className="divide-y divide-gray-200 dark:divide-gray-800">
              {loading ? (
                <tr>
                  <td
                    colSpan={5}
                    className="py-10 px-6 text-center text-sm text-gray-500 dark:text-gray-400"
                  >
                    Loading verification requests...
                  </td>
                </tr>
              ) : requests.length === 0 ? (
                <tr>
                  <td
                    colSpan={5}
                    className="py-10 px-6 text-center text-sm text-gray-500 dark:text-gray-400"
                  >
                    No pending verification requests found.
                  </td>
                </tr>
              ) : (
                requests.map((r) => (
                  <tr
                    key={r.verificationId}
                    className="hover:bg-gray-50 dark:hover:bg-surface-darker/50 transition-colors"
                  >
                    <td className="py-4 px-6">
                      <div className="flex items-center gap-3">
                        <div className="w-10 h-10 rounded-full bg-primary/20 flex items-center justify-center text-primary font-bold">
                          {r.guideSnapshot?.firstName?.[0] ?? ""}
                          {r.guideSnapshot?.lastName?.[0] ?? ""}
                        </div>
                        <div>
                          <p className="text-sm font-medium text-gray-900 dark:text-white">
                            {r.guideSnapshot?.firstName ?? "Unknown"} {r.guideSnapshot?.lastName ?? ""}
                          </p>
                          <p className="text-xs text-gray-500 dark:text-gray-400">
                            {r.guideSnapshot?.email ?? "No email"}
                          </p>
                        </div>
                      </div>
                    </td>

                    <td className="py-4 px-6">
                      <span className="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-purple-100 text-purple-800 dark:bg-purple-900/30 dark:text-purple-300">
                        Guide
                      </span>
                    </td>

                    <td className="py-4 px-6 text-sm text-gray-500 dark:text-gray-400">
                      {formatDate(r.submittedAt)}
                    </td>

                    <td className="py-4 px-6">
                      <div className="flex items-center gap-2">
                        <span className="w-2 h-2 rounded-full bg-yellow-500 animate-pulse" />
                        <span className="text-sm font-medium text-yellow-600 dark:text-yellow-400 capitalize">
                          {r.status}
                        </span>
                      </div>
                    </td>

                    <td className="py-4 px-6 text-right">
                      <Link
                        href={`/admin/verifications/${r.verificationId}`}
                        className="inline-flex items-center justify-center px-3 py-2 text-xs font-medium text-primary bg-primary/10 hover:bg-primary hover:text-white rounded-lg transition-colors"
                      >
                        Review
                      </Link>
                    </td>
                  </tr>
                ))
              )}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
}