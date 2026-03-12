"use client"; // make this a client component

import { useState, useEffect } from "react";

export default function DashboardPage() {
  const [stats, setStats] = useState({
    totalUsers: 0,
    guides: 0,
    tourists: 0,
    pending: 0,
  });

  useEffect(() => {
    const fetchStats = async () => {
      try {
        const res = await fetch("http://localhost:3000/api/admin/dashboard-stats");
        if (!res.ok) throw new Error("Failed to fetch stats");
        const data = await res.json();
        setStats(data);
      } catch (err) {
        console.error(err);
      }
    };

    fetchStats();
  }, []);

  return (
    <div className="max-w-7xl mx-auto space-y-8">
      <div>
        <h1 className="text-2xl font-bold text-gray-900 dark:text-white">
          Dashboard Overview
        </h1>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        {/* Total Users */}
        <div className="bg-white dark:bg-surface-dark p-6 rounded-xl border border-gray-200 dark:border-gray-800 shadow-sm relative overflow-hidden">
          <div className="absolute right-0 top-0 p-4 opacity-10">
            <span className="material-icons text-6xl text-primary">groups</span>
          </div>
          <p className="text-sm font-medium text-gray-500 dark:text-gray-400">Total Users</p>
          <div className="mt-2 flex items-baseline gap-2">
            <span className="text-3xl font-bold text-gray-900 dark:text-white">{stats.totalUsers}</span>
          </div>
        </div>

        {/* Pending Verifications */}
        <div className="bg-white dark:bg-surface-dark p-6 rounded-xl border border-l-4 border-gray-200 dark:border-gray-800 border-l-yellow-500 shadow-sm relative overflow-hidden">
          <div className="absolute right-0 top-0 p-4 opacity-10">
            <span className="material-icons text-6xl text-yellow-500">pending_actions</span>
          </div>
          <p className="text-sm font-medium text-gray-500 dark:text-gray-400">Pending Verifications</p>
          <div className="mt-2 flex items-baseline gap-2">
            <span className="text-3xl font-bold text-gray-900 dark:text-white">{stats.pending}</span>
            <span className="text-xs font-medium text-yellow-500 bg-yellow-500/10 px-2 py-0.5 rounded">
              Needs Attention
            </span>
          </div>
        </div>

        {/* Active Guides */}
        <div className="bg-white dark:bg-surface-dark p-6 rounded-xl border border-gray-200 dark:border-gray-800 shadow-sm relative overflow-hidden">
          <div className="absolute right-0 top-0 p-4 opacity-10">
            <span className="material-icons text-6xl text-blue-400">map</span>
          </div>
          <p className="text-sm font-medium text-gray-500 dark:text-gray-400">Active Guides</p>
          <div className="mt-2 flex items-baseline gap-2">
            <span className="text-3xl font-bold text-gray-900 dark:text-white">{stats.guides}</span>
          </div>
        </div>

        {/* Tourists */}
        <div className="bg-white dark:bg-surface-dark p-6 rounded-xl border border-gray-200 dark:border-gray-800 shadow-sm relative overflow-hidden">
          <div className="absolute right-0 top-0 p-4 opacity-10">
            <span className="material-icons text-6xl text-green-500">payments</span>
          </div>
          <p className="text-sm font-medium text-gray-500 dark:text-gray-400">Tourists</p>
          <div className="mt-2 flex items-baseline gap-2">
            <span className="text-3xl font-bold text-gray-900 dark:text-white">{stats.tourists}</span>
          </div>
        </div>
      </div>

      {/* Recent Verification Requests table stays the same */}
      {/* ...rest of your JSX untouched */}
    </div>
  );
}