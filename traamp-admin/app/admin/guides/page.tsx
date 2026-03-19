"use client";

import Link from "next/link";
import { useEffect, useMemo, useState } from "react";

type Guide = {
  uid: string;
  firstName?: string;
  lastName?: string;
  email?: string;
  phoneNumber?: string;
  location?: string;
  isVerified?: boolean;
  badgeIssued?: boolean;
  currentVerificationStatus?: string;
  createdAt?: any;
};

export default function GuidesPage() {
  const [guides, setGuides] = useState<Guide[]>([]);
  const [loading, setLoading] = useState(true);
  const [search, setSearch] = useState("");
  const [statusFilter, setStatusFilter] = useState("all");

  useEffect(() => {
    const fetchGuides = async () => {
      try {
        const res = await fetch(
          `${process.env.NEXT_PUBLIC_API_URL}/api/admin/guides`
        );
        const data = await res.json();

        if (!res.ok) {
          throw new Error(data.error || "Failed to fetch guides");
        }

        setGuides(Array.isArray(data) ? data : []);
      } catch (error) {
        console.error(error);
      } finally {
        setLoading(false);
      }
    };

    fetchGuides();
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

  const getGuideStatus = (guide: Guide) => {
    return guide.currentVerificationStatus || "not_submitted";
  };

  const getStatusLabel = (status?: string) => {
    switch (status) {
      case "pending":
        return "Pending";
      case "approved":
        return "Approved";
      case "rejected":
        return "Rejected";
      case "not_submitted":
      default:
        return "Not Submitted";
    }
  };

  const getStatusClasses = (status?: string) => {
    switch (status) {
      case "pending":
        return "bg-yellow-100 text-yellow-800 dark:bg-yellow-900/30 dark:text-yellow-400";
      case "approved":
        return "bg-green-100 text-green-800 dark:bg-green-900/30 dark:text-green-400";
      case "rejected":
        return "bg-red-100 text-red-800 dark:bg-red-900/30 dark:text-red-400";
      case "not_submitted":
      default:
        return "bg-gray-100 text-gray-800 dark:bg-gray-900/30 dark:text-gray-400";
    }
  };

  const stats = useMemo(() => {
    const totalGuides = guides.length;
    const verifiedGuides = guides.filter((g) => g.isVerified === true).length;
    const pendingGuides = guides.filter(
      (g) => getGuideStatus(g) === "pending"
    ).length;
    const rejectedGuides = guides.filter(
      (g) => getGuideStatus(g) === "rejected"
    ).length;

    return {
      totalGuides,
      verifiedGuides,
      pendingGuides,
      rejectedGuides,
    };
  }, [guides]);

  const filteredGuides = useMemo(() => {
    return guides.filter((guide) => {
      const fullName =
        `${guide.firstName || ""} ${guide.lastName || ""}`.toLowerCase();
      const email = (guide.email || "").toLowerCase();
      const location = (guide.location || "").toLowerCase();
      const q = search.toLowerCase();

      const matchesSearch =
        fullName.includes(q) || email.includes(q) || location.includes(q);

      const guideStatus = getGuideStatus(guide);

      const matchesStatus =
        statusFilter === "all" ? true : guideStatus === statusFilter;

      return matchesSearch && matchesStatus;
    });
  }, [guides, search, statusFilter]);

  return (
    <div className="max-w-7xl mx-auto space-y-6">
      <div className="flex flex-col md:flex-row md:items-end md:justify-between gap-4">
        <div>
          <h1 className="text-2xl font-bold text-gray-900 dark:text-white">
            Guide Management
          </h1>
          <p className="text-gray-500 dark:text-gray-400 mt-1">
            View and manage all registered guides.
          </p>
        </div>

        <div className="flex gap-3 flex-col sm:flex-row">
          <input
            type="text"
            placeholder="Search by name, email, location..."
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            className="px-4 py-2 rounded-lg border border-gray-300 dark:border-gray-700 bg-white dark:bg-surface-dark text-sm"
          />

          <select
            value={statusFilter}
            onChange={(e) => setStatusFilter(e.target.value)}
            className="px-4 py-2 rounded-lg border border-gray-300 dark:border-gray-700 bg-white dark:bg-surface-dark text-sm"
          >
            <option value="all">All Status</option>
            <option value="not_submitted">Not Submitted</option>
            <option value="pending">Pending</option>
            <option value="approved">Approved</option>
            <option value="rejected">Rejected</option>
          </select>
        </div>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-4 gap-6">
        <div className="bg-white dark:bg-surface-dark p-6 rounded-xl border border-gray-200 dark:border-gray-800 shadow-sm">
          <p className="text-sm font-medium text-gray-500 dark:text-gray-400">
            Total Guides
          </p>
          <div className="mt-2">
            <span className="text-3xl font-bold text-gray-900 dark:text-white">
              {stats.totalGuides}
            </span>
          </div>
        </div>

        <div className="bg-white dark:bg-surface-dark p-6 rounded-xl border border-gray-200 dark:border-gray-800 shadow-sm">
          <p className="text-sm font-medium text-gray-500 dark:text-gray-400">
            Verified Guides
          </p>
          <div className="mt-2">
            <span className="text-3xl font-bold text-green-600 dark:text-green-400">
              {stats.verifiedGuides}
            </span>
          </div>
        </div>

        <div className="bg-white dark:bg-surface-dark p-6 rounded-xl border border-gray-200 dark:border-gray-800 shadow-sm">
          <p className="text-sm font-medium text-gray-500 dark:text-gray-400">
            Pending Verification
          </p>
          <div className="mt-2">
            <span className="text-3xl font-bold text-yellow-600 dark:text-yellow-400">
              {stats.pendingGuides}
            </span>
          </div>
        </div>

        <div className="bg-white dark:bg-surface-dark p-6 rounded-xl border border-gray-200 dark:border-gray-800 shadow-sm">
          <p className="text-sm font-medium text-gray-500 dark:text-gray-400">
            Rejected Guides
          </p>
          <div className="mt-2">
            <span className="text-3xl font-bold text-red-600 dark:text-red-400">
              {stats.rejectedGuides}
            </span>
          </div>
        </div>
      </div>

      <div className="bg-white dark:bg-surface-dark rounded-xl border border-gray-200 dark:border-gray-800 overflow-hidden shadow-sm">
        <div className="overflow-x-auto">
          <table className="w-full text-left border-collapse">
            <thead>
              <tr className="bg-gray-50 dark:bg-surface-darker border-b border-gray-200 dark:border-gray-800">
                <th className="py-4 px-6 text-xs font-semibold uppercase tracking-wider text-gray-500 dark:text-gray-400">
                  Guide
                </th>
                <th className="py-4 px-6 text-xs font-semibold uppercase tracking-wider text-gray-500 dark:text-gray-400">
                  Location
                </th>
                <th className="py-4 px-6 text-xs font-semibold uppercase tracking-wider text-gray-500 dark:text-gray-400">
                  Verification
                </th>
                <th className="py-4 px-6 text-xs font-semibold uppercase tracking-wider text-gray-500 dark:text-gray-400">
                  Badge
                </th>
                <th className="py-4 px-6 text-xs font-semibold uppercase tracking-wider text-gray-500 dark:text-gray-400">
                  Joined
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
                    colSpan={6}
                    className="py-10 px-6 text-center text-sm text-gray-500 dark:text-gray-400"
                  >
                    Loading guides...
                  </td>
                </tr>
              ) : filteredGuides.length === 0 ? (
                <tr>
                  <td
                    colSpan={6}
                    className="py-10 px-6 text-center text-sm text-gray-500 dark:text-gray-400"
                  >
                    No guides found.
                  </td>
                </tr>
              ) : (
                filteredGuides.map((guide) => {
                  const guideStatus = getGuideStatus(guide);

                  return (
                    <tr
                      key={guide.uid}
                      className="hover:bg-gray-50 dark:hover:bg-surface-darker/50 transition-colors"
                    >
                      <td className="py-4 px-6">
                        <div className="flex items-center gap-3">
                          <div className="w-10 h-10 rounded-full bg-primary/20 flex items-center justify-center text-primary font-bold">
                            {guide.firstName?.[0] ?? ""}
                            {guide.lastName?.[0] ?? ""}
                          </div>
                          <div>
                            <div className="flex items-center gap-2">
                              <p className="text-sm font-medium text-gray-900 dark:text-white">
                                {guide.firstName || "Unknown"}{" "}
                                {guide.lastName || ""}
                              </p>
                              {guide.isVerified ? (
                                <span className="material-icons text-green-500 text-base">
                                  verified
                                </span>
                              ) : null}
                            </div>
                            <p className="text-xs text-gray-500 dark:text-gray-400">
                              {guide.email || "No email"}
                            </p>
                            <p className="text-xs text-gray-500 dark:text-gray-400">
                              {guide.phoneNumber || "No phone"}
                            </p>
                          </div>
                        </div>
                      </td>

                      <td className="py-4 px-6 text-sm text-gray-600 dark:text-gray-300">
                        {guide.location || "N/A"}
                      </td>

                      <td className="py-4 px-6">
                        <span
                          className={`inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium ${getStatusClasses(
                            guideStatus
                          )}`}
                        >
                          {getStatusLabel(guideStatus)}
                        </span>
                      </td>

                      <td className="py-4 px-6">
                        {guide.badgeIssued ? (
                          <span className="inline-flex items-center gap-1 px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800 dark:bg-green-900/30 dark:text-green-400">
                            <span className="material-icons text-sm">
                              verified
                            </span>
                            Issued
                          </span>
                        ) : (
                          <span className="inline-flex items-center gap-1 px-2.5 py-0.5 rounded-full text-xs font-medium bg-gray-100 text-gray-800 dark:bg-gray-900/30 dark:text-gray-400">
                            <span className="material-icons text-sm">
                              remove_moderator
                            </span>
                            Not Issued
                          </span>
                        )}
                      </td>

                      <td className="py-4 px-6 text-sm text-gray-500 dark:text-gray-400">
                        {formatDate(guide.createdAt)}
                      </td>

                      <td className="py-4 px-6 text-right">
                        <Link
                          href={`/admin/guides/${guide.uid}`}
                          className="inline-flex items-center justify-center px-3 py-2 text-xs font-medium text-primary bg-primary/10 hover:bg-primary hover:text-white rounded-lg transition-colors"
                        >
                          View
                        </Link>
                      </td>
                    </tr>
                  );
                })
              )}
            </tbody>
          </table>
        </div>

        <div className="px-6 py-4 border-t border-gray-200 dark:border-gray-800 bg-gray-50 dark:bg-surface-darker/30">
          <p className="text-xs text-gray-500 dark:text-gray-400">
            Showing {filteredGuides.length} guide
            {filteredGuides.length !== 1 ? "s" : ""}
          </p>
        </div>
      </div>
    </div>
  );
}