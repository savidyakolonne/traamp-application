"use client";

import { useState, useEffect } from "react";

function Status({ status }: { status: string }) {
  if (status === "active" || !status)
    return (
      <span className="inline-flex items-center px-2 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800 dark:bg-green-900/30 dark:text-green-400">
        <span className="w-1.5 h-1.5 bg-green-400 rounded-full mr-1.5" /> Active
      </span>
    );

  return (
    <span className="inline-flex items-center px-2 py-0.5 rounded-full text-xs font-medium bg-red-100 text-red-800 dark:bg-red-900/30 dark:text-red-400">
      <span className="w-1.5 h-1.5 bg-red-400 rounded-full mr-1.5" /> Suspended
    </span>
  );
}

export default function TouristsPage() {
  const [tourists, setTourists] = useState<any[]>([]);

  useEffect(() => {
    async function fetchTourists() {
      try {
        const res = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/admin/tourists`);
        const data = await res.json();
        setTourists(data);
      } catch (err) {
        console.error(err);
      }
    }
    fetchTourists();
  }, []);

  return (
    <div className="max-w-7xl mx-auto space-y-6">
      <h1 className="text-2xl font-bold text-gray-900 dark:text-white">Tourist Management</h1>

      <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
        <div className="bg-white dark:bg-surface-dark p-4 rounded-xl border border-gray-200 dark:border-gray-800">
          <p className="text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">
            Total Tourists
          </p>
          <p className="text-2xl font-bold text-gray-900 dark:text-white">
            {tourists.length}
          </p>
        </div>

        <div className="bg-white dark:bg-surface-dark p-4 rounded-xl border border-gray-200 dark:border-gray-800">
          <p className="text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">
            Suspended
          </p>
          <p className="text-2xl font-bold text-red-500 mt-1">
            {tourists.filter((t) => t.accountStatus === "suspended").length}
          </p>
        </div>
      </div>

      <div className="bg-white dark:bg-surface-dark rounded-xl border border-gray-200 dark:border-gray-800 shadow-sm overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full text-left border-collapse">
            <thead className="bg-gray-50 dark:bg-surface-darker border-b border-gray-200 dark:border-gray-800">
              <tr>
                <th className="px-6 py-4 text-xs font-semibold text-gray-500 dark:text-gray-400 uppercase tracking-wider">
                  Tourist
                </th>
                <th className="px-6 py-4 text-xs font-semibold text-gray-500 dark:text-gray-400 uppercase tracking-wider">
                  Country
                </th>
                <th className="px-6 py-4 text-xs font-semibold text-gray-500 dark:text-gray-400 uppercase tracking-wider">
                  Email
                </th>
                <th className="px-6 py-4 text-xs font-semibold text-gray-500 dark:text-gray-400 uppercase tracking-wider">
                  Status
                </th>
              </tr>
            </thead>

            <tbody className="divide-y divide-gray-200 dark:divide-gray-800">
              {tourists.map((t) => (
                <tr
                  key={t.uid}
                  className="hover:bg-gray-50 dark:hover:bg-surface-darker/50 transition-colors"
                >
                  <td className="px-6 py-4">
                    {t.firstName} {t.lastName}
                  </td>
                  <td className="px-6 py-4">{t.country}</td>
                  <td className="px-6 py-4">{t.email}</td>
                  <td className="px-6 py-4">
                    <Status status={t.accountStatus} />
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
}