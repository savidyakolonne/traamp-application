"use client";

import Link from "next/link";
import { useEffect, useMemo, useState } from "react";
import { useParams, useRouter } from "next/navigation";

type GuideVerification = {
  uid: string;
  firstName?: string;
  lastName?: string;
  email?: string;
  phoneNumber?: string;
  website?: string;
  location?: string;
  createdAt?: any;
  bio?: string;
  verificationStatus?: string;
  nicImageUrl?: string;
  sltdaCertificateUrl?: string;
  nicNumber?: string;
  certificateNumber?: string;
  verificationRequestedAt?: any;
};

export default function VerificationDetailPage() {
  const params = useParams();
  const router = useRouter();
  const id = params?.id as string;

  const [guide, setGuide] = useState<GuideVerification | null>(null);
  const [activeTab, setActiveTab] = useState<"nic" | "certificate">("nic");
  const [note, setNote] = useState("");
  const [loading, setLoading] = useState(true);
  const [actionLoading, setActionLoading] = useState(false);
  const [error, setError] = useState("");

  useEffect(() => {
    const fetchGuide = async () => {
      try {
        setLoading(true);
        setError("");

        const res = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/admin/verifications/${id}`);
        const data = await res.json();

        if (!res.ok) {
          throw new Error(data.error || "Failed to fetch verification request");
        }

        setGuide(data);
      } catch (err: any) {
        console.error(err);
        setError(err.message || "Something went wrong");
      } finally {
        setLoading(false);
      }
    };

    if (id) fetchGuide();
  }, [id]);

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

  const guideName = useMemo(() => {
    if (!guide) return "";
    return `${guide.firstName || ""} ${guide.lastName || ""}`.trim();
  }, [guide]);

  const initials = useMemo(() => {
    if (!guideName) return "GD";
    return guideName
      .split(" ")
      .map((x) => x[0])
      .slice(0, 2)
      .join("")
      .toUpperCase();
  }, [guideName]);

  const currentDocumentUrl =
    activeTab === "nic" ? guide?.nicImageUrl : guide?.sltdaCertificateUrl;

  const currentFileLabel =
    activeTab === "nic" ? "NIC Document" : "SLTDA Certificate";

  const handleApprove = async () => {
    try {
      setActionLoading(true);

      const res = await fetch(
        `http://localhost:3000/api/admin/verifications/${id}/approve`,
        {
          method: "PUT",
          headers: {
            "Content-Type": "application/json",
          },
          body: JSON.stringify({ note }),
        }
      );

      const data = await res.json();

      if (!res.ok) {
        throw new Error(data.error || "Failed to approve verification");
      }

      alert("Guide verification approved successfully");
      router.push("/admin/verifications");
      router.refresh();
    } catch (err: any) {
      console.error(err);
      alert(err.message || "Failed to approve verification");
    } finally {
      setActionLoading(false);
    }
  };

  const handleReject = async () => {
    try {
      setActionLoading(true);

      const res = await fetch(
        `${process.env.NEXT_PUBLIC_API_URL}/api/admin/verifications/${id}/reject`,
        {
          method: "PUT",
          headers: {
            "Content-Type": "application/json",
          },
          body: JSON.stringify({ note }),
        }
      );

      const data = await res.json();

      if (!res.ok) {
        throw new Error(data.error || "Failed to reject verification");
      }

      alert("Guide verification rejected successfully");
      router.push("/admin/verifications");
      router.refresh();
    } catch (err: any) {
      console.error(err);
      alert(err.message || "Failed to reject verification");
    } finally {
      setActionLoading(false);
    }
  };

  const getStatusLabel = (status?: string) => {
    switch (status) {
      case "pending":
        return "Pending";
      case "verified":
        return "Verified";
      case "rejected":
        return "Rejected";
      default:
        return "Unknown";
    }
  };

  const getStatusClasses = (status?: string) => {
    switch (status) {
      case "pending":
        return "bg-yellow-100 text-yellow-800 dark:bg-yellow-900/30 dark:text-yellow-400 border border-yellow-200 dark:border-yellow-900/50";
      case "verified":
        return "bg-green-100 text-green-800 dark:bg-green-900/30 dark:text-green-400 border border-green-200 dark:border-green-900/50";
      case "rejected":
        return "bg-red-100 text-red-800 dark:bg-red-900/30 dark:text-red-400 border border-red-200 dark:border-red-900/50";
      default:
        return "bg-gray-100 text-gray-800 dark:bg-gray-900/30 dark:text-gray-400 border border-gray-200 dark:border-gray-800";
    }
  };

  if (loading) {
    return (
      <div className="max-w-7xl mx-auto py-10 text-sm text-gray-500 dark:text-gray-400">
        Loading verification request...
      </div>
    );
  }

  if (error || !guide) {
    return (
      <div className="max-w-7xl mx-auto py-10 space-y-4">
        <p className="text-sm text-red-600 dark:text-red-400">
          {error || "Verification request not found"}
        </p>
        <Link
          href="/admin/verifications"
          className="inline-flex items-center px-4 py-2 rounded-lg bg-primary/10 text-primary hover:bg-primary hover:text-white transition-colors text-sm font-medium"
        >
          Back to Verification Queue
        </Link>
      </div>
    );
  }

  return (
    <div className="max-w-7xl mx-auto space-y-6">
      <div className="flex items-center justify-between">
        <div className="flex items-center gap-3">
          <Link
            href="/admin/verifications"
            className="p-2 rounded-lg hover:bg-gray-100 dark:hover:bg-gray-800 text-gray-500 dark:text-gray-400"
          >
            <span className="material-icons">arrow_back</span>
          </Link>

          <div>
            <p className="text-xs text-gray-500 dark:text-gray-400">Guide UID</p>
            <h1 className="text-xl font-bold text-gray-900 dark:text-white">
              {id}
            </h1>
          </div>

          <span
            className={`ml-2 px-2.5 py-0.5 rounded-full text-xs font-medium ${getStatusClasses(
              guide.verificationStatus
            )}`}
          >
            {getStatusLabel(guide.verificationStatus)}
          </span>
        </div>

        <div className="text-right">
          <p className="text-xs text-gray-500 dark:text-gray-400">Reviewer</p>
          <p className="text-sm font-medium text-gray-900 dark:text-white">
            Admin
          </p>
        </div>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-12 gap-8">
        {/* LEFT */}
        <div className="lg:col-span-4 space-y-6">
          <div className="bg-white dark:bg-surface-darker rounded-xl border border-gray-200 dark:border-gray-800 p-6 shadow-sm">
            <div className="flex flex-col items-center text-center">
              <div className="h-24 w-24 rounded-full bg-primary/20 flex items-center justify-center text-primary text-3xl font-bold">
                {initials}
              </div>

              <h2 className="mt-4 text-xl font-bold text-gray-900 dark:text-white">
                {guideName || "Unnamed Guide"}
              </h2>

              <p className="text-sm text-gray-500 dark:text-gray-400">
                Verified Guide Applicant
              </p>

              <div className="mt-6 w-full space-y-4">
                <div className="flex justify-between items-center py-2 border-b border-gray-100 dark:border-gray-800">
                  <span className="text-sm text-gray-500 dark:text-gray-400">
                    NIC Number
                  </span>
                  <span className="text-sm font-mono font-medium">
                    {guide.nicNumber || "N/A"}
                  </span>
                </div>

                <div className="flex justify-between items-center py-2 border-b border-gray-100 dark:border-gray-800">
                  <span className="text-sm text-gray-500 dark:text-gray-400">
                    Certificate Number
                  </span>
                  <span className="text-sm font-medium">
                    {guide.certificateNumber || "N/A"}
                  </span>
                </div>

                <div className="flex justify-between items-center py-2 border-b border-gray-100 dark:border-gray-800">
                  <span className="text-sm text-gray-500 dark:text-gray-400">
                    Location
                  </span>
                  <span className="text-sm font-medium flex items-center gap-1">
                    <span className="material-icons text-xs text-primary">
                      location_on
                    </span>
                    {guide.location || "N/A"}
                  </span>
                </div>

                <div className="flex justify-between items-center py-2 border-b border-gray-100 dark:border-gray-800">
                  <span className="text-sm text-gray-500 dark:text-gray-400">
                    Joined
                  </span>
                  <span className="text-sm font-medium">
                    {formatDate(guide.createdAt)}
                  </span>
                </div>

                <div className="flex justify-between items-center py-2 border-b border-gray-100 dark:border-gray-800">
                  <span className="text-sm text-gray-500 dark:text-gray-400">
                    Requested
                  </span>
                  <span className="text-sm font-medium">
                    {formatDate(guide.verificationRequestedAt)}
                  </span>
                </div>

                <div className="flex flex-col items-start gap-1 py-2">
                  <span className="text-sm text-gray-500 dark:text-gray-400">
                    Bio
                  </span>
                  <p className="text-sm text-gray-600 dark:text-gray-300 leading-relaxed text-left">
                    {guide.bio || "No bio available."}
                  </p>
                </div>
              </div>
            </div>
          </div>

          <div className="bg-gradient-to-br from-primary/10 to-primary/5 dark:from-primary/20 dark:to-background-dark rounded-xl border border-primary/20 p-6 relative overflow-hidden">
            <div className="absolute top-0 right-0 p-4 opacity-10">
              <span className="material-icons text-9xl text-primary rotate-12 translate-x-4 -translate-y-4">
                verified
              </span>
            </div>

            <div className="relative z-10">
              <h3 className="text-xs font-semibold uppercase tracking-wider text-primary mb-4">
                Badge Preview
              </h3>

              <div className="bg-white dark:bg-gray-800/80 rounded-lg p-4 shadow-lg border border-white/20 flex items-center gap-4">
                <div className="h-12 w-12 rounded-full bg-primary flex items-center justify-center text-white shrink-0">
                  <span className="material-icons">verified_user</span>
                </div>
                <div>
                  <p className="font-bold text-gray-900 dark:text-white">
                    Verified Guide
                  </p>
                  <p className="text-xs text-gray-500 dark:text-gray-300">
                    Visible on the guide profile after approval
                  </p>
                </div>
                <span className="ml-auto h-2 w-2 rounded-full bg-green-500 animate-pulse" />
              </div>

              <p className="mt-4 text-xs text-gray-500 dark:text-gray-400">
                This badge will be displayed on the guide&apos;s public profile
                upon approval.
              </p>
            </div>
          </div>

          <div className="bg-white dark:bg-surface-darker rounded-xl border border-gray-200 dark:border-gray-800 p-6 shadow-sm">
            <h3 className="text-sm font-semibold text-gray-900 dark:text-white mb-4">
              Contact Details
            </h3>

            <ul className="space-y-3">
              <li className="flex items-center gap-3 text-sm text-gray-600 dark:text-gray-300">
                <span className="material-icons text-gray-400 text-lg">
                  email
                </span>
                {guide.email || "N/A"}
              </li>

              <li className="flex items-center gap-3 text-sm text-gray-600 dark:text-gray-300">
                <span className="material-icons text-gray-400 text-lg">
                  phone
                </span>
                {guide.phoneNumber || "N/A"}
              </li>

              <li className="flex items-center gap-3 text-sm text-gray-600 dark:text-gray-300">
                <span className="material-icons text-gray-400 text-lg">
                  badge
                </span>
                {guide.nicNumber || "N/A"}
              </li>
            </ul>
          </div>
        </div>

        {/* RIGHT */}
        <div className="lg:col-span-8 space-y-6">
          <div className="bg-white dark:bg-surface-darker rounded-xl border border-gray-200 dark:border-gray-800 shadow-sm overflow-hidden min-h-[600px] flex flex-col">
            <div className="flex border-b border-gray-200 dark:border-gray-800 bg-gray-50 dark:bg-surface-dark">
              <button
                onClick={() => setActiveTab("nic")}
                className={`px-6 py-4 text-sm font-medium flex items-center gap-2 ${
                  activeTab === "nic"
                    ? "text-primary border-b-2 border-primary bg-white dark:bg-surface-darker"
                    : "text-gray-500 dark:text-gray-400 hover:text-gray-700 dark:hover:text-gray-200 hover:bg-gray-100 dark:hover:bg-gray-800/50"
                }`}
              >
                <span className="material-icons text-lg">badge</span>
                NIC
              </button>

              <button
                onClick={() => setActiveTab("certificate")}
                className={`px-6 py-4 text-sm font-medium flex items-center gap-2 ${
                  activeTab === "certificate"
                    ? "text-primary border-b-2 border-primary bg-white dark:bg-surface-darker"
                    : "text-gray-500 dark:text-gray-400 hover:text-gray-700 dark:hover:text-gray-200 hover:bg-gray-100 dark:hover:bg-gray-800/50"
                }`}
              >
                <span className="material-icons text-lg">school</span>
                Guide Certificate
              </button>
            </div>

            <div className="flex-1 bg-gray-100 dark:bg-[#0b1119] relative p-8 flex items-center justify-center overflow-hidden">
              <div
                className="absolute inset-0 opacity-5 pointer-events-none"
                style={{
                  backgroundImage: "radial-gradient(#64748b 1px, transparent 1px)",
                  backgroundSize: "20px 20px",
                }}
              />

              {currentDocumentUrl ? (
                <div className="relative shadow-2xl rounded bg-white max-w-full max-h-full transition-transform duration-200 ease-in-out hover:scale-[1.02]">
                  <img
                    alt={currentFileLabel}
                    className="max-h-[500px] w-auto object-contain rounded border border-gray-200 dark:border-gray-700"
                    src={currentDocumentUrl}
                  />
                </div>
              ) : (
                <div className="relative z-10 text-center text-sm text-gray-500 dark:text-gray-400">
                  No {activeTab === "nic" ? "NIC document" : "certificate"} uploaded.
                </div>
              )}
            </div>

            <div className="bg-white dark:bg-surface-darker border-t border-gray-200 dark:border-gray-800 p-4 flex items-center justify-between text-xs text-gray-500 dark:text-gray-400">
              <div className="flex items-center gap-4 flex-wrap">
                <span>
                  Document: <strong>{currentFileLabel}</strong>
                </span>
                <span>
                  Submitted:{" "}
                  <strong>{formatDate(guide.verificationRequestedAt)}</strong>
                </span>
              </div>

              {currentDocumentUrl ? (
                <a
                  href={currentDocumentUrl}
                  target="_blank"
                  rel="noreferrer"
                  className="text-primary hover:opacity-80 flex items-center gap-1 font-medium"
                >
                  <span className="material-icons text-sm">open_in_new</span>
                  Open Original
                </a>
              ) : null}
            </div>
          </div>

          <div className="bg-white dark:bg-surface-darker rounded-xl border border-gray-200 dark:border-gray-800 p-6 shadow-lg sticky bottom-6">
            <div className="flex flex-col md:flex-row items-start md:items-center justify-between gap-4">
              <div className="flex-grow w-full md:w-auto">
                <div className="relative">
                  <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                    <span className="material-icons text-gray-400">
                      edit_note
                    </span>
                  </div>
                  <input
                    className="block w-full pl-10 pr-3 py-2 border border-gray-300 dark:border-gray-700 rounded-lg bg-gray-50 dark:bg-gray-800 text-gray-900 dark:text-white placeholder-gray-500 focus:ring-1 focus:ring-primary focus:border-primary text-sm"
                    placeholder="Add optional note for rejection or approval..."
                    type="text"
                    value={note}
                    onChange={(e) => setNote(e.target.value)}
                  />
                </div>
              </div>

              <div className="flex items-center gap-3 w-full md:w-auto">
                <button
                  onClick={handleReject}
                  disabled={actionLoading}
                  className="flex-1 md:flex-none justify-center px-4 py-2 border border-red-200 dark:border-red-900/50 text-red-600 dark:text-red-400 bg-red-50 dark:bg-red-900/10 hover:bg-red-100 dark:hover:bg-red-900/20 rounded-lg text-sm font-medium flex items-center gap-2 disabled:opacity-50"
                >
                  <span className="material-icons text-lg">close</span>
                  {actionLoading ? "Processing..." : "Reject"}
                </button>

                <button
                  onClick={handleApprove}
                  disabled={actionLoading}
                  className="flex-1 md:flex-none justify-center px-6 py-2 border border-transparent text-white bg-primary hover:opacity-90 rounded-lg text-sm font-medium shadow-sm flex items-center gap-2 disabled:opacity-50"
                >
                  <span className="material-icons text-lg">check_circle</span>
                  {actionLoading ? "Processing..." : "Approve & Issue Badge"}
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
