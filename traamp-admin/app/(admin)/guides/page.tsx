"use client";

import { useState, useEffect } from "react";
import Link from "next/link";

function StatusPill({ status }: { status: string }) {
  if (status === "Verified")
    return (
      <span className="inline-flex items-center gap-1 px-2 py-1 rounded-full text-xs font-medium bg-green-100 text-green-800 dark:bg-green-900/30 dark:text-green-400">
        <span className="w-1.5 h-1.5 rounded-full bg-green-400" />
        Verified
      </span>
    );
  if (status === "pending")
    return (
      <span className="inline-flex items-center gap-1 px-2 py-1 rounded-full text-xs font-medium bg-yellow-100 text-yellow-800 dark:bg-yellow-900/30 dark:text-yellow-400">
        <span className="w-1.5 h-1.5 rounded-full bg-yellow-400 animate-pulse" />
        Pending
      </span>
    );
  return (
    <span className="inline-flex items-center gap-1 px-2 py-1 rounded-full text-xs font-medium bg-red-100 text-red-800 dark:bg-red-900/30 dark:text-red-400">
      Suspended
    </span>
  );
}

export default function GuidesPage() {
  const [guides, setGuides] = useState<any[]>([]);

  useEffect(() => {
    async function fetchGuides() {
      try {
        const res = await fetch("http://localhost:3000/api/admin/guides");
        const data = await res.json();
        setGuides(data);
      } catch (err) {
        console.error(err);
      }
    }
    fetchGuides();
  }, []);

  return (
    <div className="max-w-7xl mx-auto space-y-6">
      <h1 className="text-2xl font-bold text-gray-900 dark:text-white">Guide Management</h1>

      {/* Stats Cards */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
        <div className="bg-white dark:bg-surface-dark p-4 rounded-xl border border-gray-200 dark:border-gray-800">
          <p className="text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">Total Guides</p>
          <p className="text-2xl font-bold text-gray-900 dark:text-white">{guides.length}</p>
        </div>
        <div className="bg-white dark:bg-surface-dark p-4 rounded-xl border border-gray-200 dark:border-gray-800">
          <p className="text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">Pending Verification</p>
          <p className="text-2xl font-bold text-yellow-500 mt-1">{guides.filter(g => g.verificationStatus === "pending").length}</p>
        </div>
        <div className="bg-white dark:bg-surface-dark p-4 rounded-xl border border-gray-200 dark:border-gray-800">
          <p className="text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">Verified</p>
          <p className="text-2xl font-bold text-green-500 mt-1">{guides.filter(g => g.verificationStatus === "Verified").length}</p>
        </div>
        <div className="bg-white dark:bg-surface-dark p-4 rounded-xl border border-gray-200 dark:border-gray-800">
          <p className="text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">Suspended</p>
          <p className="text-2xl font-bold text-red-500 mt-1">{guides.filter(g => g.verificationStatus === "Suspended").length}</p>
        </div>
      </div>

      {/* Search + Filter */}
      <div className="bg-white dark:bg-surface-dark p-4 rounded-xl border border-gray-200 dark:border-gray-800 flex flex-col md:flex-row gap-4 md:items-center md:justify-between">
        <div className="relative w-full md:w-96">
          <span className="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400 material-icons text-xl">search</span>
          <input
            className="w-full pl-10 pr-4 py-2.5 bg-gray-50 dark:bg-background-dark border border-gray-200 dark:border-gray-700 rounded-lg text-sm text-gray-900 dark:text-white focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent"
            placeholder="Search guide by name or location..."
            type="text"
          />
        </div>

        <div className="flex bg-gray-100 dark:bg-background-dark p-1 rounded-lg w-full md:w-auto overflow-x-auto">
          <button className="flex-1 md:flex-none px-4 py-1.5 text-sm font-medium text-white bg-primary rounded shadow-sm">All</button>
          <button className="flex-1 md:flex-none px-4 py-1.5 text-sm font-medium text-gray-600 dark:text-gray-400 hover:text-gray-900 dark:hover:text-white">Verified</button>
          <button className="flex-1 md:flex-none px-4 py-1.5 text-sm font-medium text-gray-600 dark:text-gray-400 hover:text-gray-900 dark:hover:text-white">Pending</button>
          <button className="flex-1 md:flex-none px-4 py-1.5 text-sm font-medium text-gray-600 dark:text-gray-400 hover:text-gray-900 dark:hover:text-white">Suspended</button>
        </div>
      </div>

      {/* Table */}
      <div className="bg-white dark:bg-surface-dark rounded-xl border border-gray-200 dark:border-gray-800 shadow-sm overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full text-left border-collapse">
            <thead className="bg-gray-50 dark:bg-surface-darker border-b border-gray-200 dark:border-gray-800">
              <tr>
                <th className="px-6 py-4 text-xs font-semibold text-gray-500 dark:text-gray-400 uppercase tracking-wider">Guide</th>
                <th className="px-6 py-4 text-xs font-semibold text-gray-500 dark:text-gray-400 uppercase tracking-wider">Location</th>
                <th className="px-6 py-4 text-xs font-semibold text-gray-500 dark:text-gray-400 uppercase tracking-wider">Languages</th>
                <th className="px-6 py-4 text-xs font-semibold text-gray-500 dark:text-gray-400 uppercase tracking-wider">Status</th>
                <th className="px-6 py-4 text-xs font-semibold text-gray-500 dark:text-gray-400 uppercase tracking-wider text-right">Actions</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-gray-200 dark:divide-gray-800">
              {guides.map(g => (
                <tr key={g.uid} className="hover:bg-gray-50 dark:hover:bg-surface-darker/50 transition-colors">
                  <td className="px-6 py-4">
                    <div className="flex items-center gap-3">
                      <div className="w-10 h-10 rounded-full bg-primary/20 flex items-center justify-center text-primary font-bold">
                        {g.firstName[0]}{g.lastName[0]}
                      </div>
                      <div>
                        <p className="font-medium text-gray-900 dark:text-white">{g.firstName} {g.lastName}</p>
                        <p className="text-xs text-gray-500 dark:text-gray-400">{g.email}</p>
                      </div>
                    </div>
                  </td>
                  <td className="px-6 py-4">{g.location}</td>
                  <td className="px-6 py-4">{g.languages?.join(", ")}</td>
                  <td className="px-6 py-4"><StatusPill status={g.verificationStatus} /></td>
                  <td className="px-6 py-4 text-right">
                    <Link href={`/admin/guides/${g.uid}`} className="inline-flex items-center px-3 py-1.5 text-xs font-medium text-primary bg-primary/10 hover:bg-primary hover:text-white rounded transition-colors">
                      {g.verificationStatus === "pending" ? "Verify" : "View Profile"}
                    </Link>
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