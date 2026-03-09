import Link from "next/link";

export default async function VerificationDetailPage({ params }: { params: Promise<{ id: string }> }) {
  const { id } = await params;

  // mock data (replace later with API call)
  const guide = {
    name: "Sarah Jenkins",
    title: "Adventure & History Guide",
    guideId: "#GUIDE-2023-849",
    location: "Kyoto, Japan",
    joined: "Oct 24, 2023",
    bio: "Certified local guide with 5+ years experience showing hidden gems. Fluent in English and Japanese. Passionate about sustainable tourism.",
    email: "sarah.j@example.com",
    phone: "+81 90-1234-5678",
    website: "www.sarah-tours.com",
    status: "Pending Review",
  };

  return (
    <div className="max-w-7xl mx-auto space-y-6">
      <div className="flex items-center justify-between">
        <div className="flex items-center gap-3">
          <Link href="/verifications" className="p-2 rounded-lg hover:bg-gray-100 dark:hover:bg-gray-800 text-gray-500 dark:text-gray-400">
            <span className="material-icons">arrow_back</span>
          </Link>

          <div>
            <p className="text-xs text-gray-500 dark:text-gray-400">Request ID</p>
            <h1 className="text-xl font-bold text-gray-900 dark:text-white">{id}</h1>
          </div>

          <span className="ml-2 px-2.5 py-0.5 rounded-full text-xs font-medium bg-yellow-100 text-yellow-800 dark:bg-yellow-900/30 dark:text-yellow-400 border border-yellow-200 dark:border-yellow-900/50">
            {guide.status}
          </span>
        </div>

        <div className="text-right">
          <p className="text-xs text-gray-500 dark:text-gray-400">Reviewer</p>
          <p className="text-sm font-medium text-gray-900 dark:text-white">Admin</p>
        </div>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-12 gap-8">
        {/* LEFT */}
        <div className="lg:col-span-4 space-y-6">
          <div className="bg-white dark:bg-surface-darker rounded-xl border border-gray-200 dark:border-gray-800 p-6 shadow-sm">
            <div className="flex flex-col items-center text-center">
              <div className="h-24 w-24 rounded-full bg-primary/20 flex items-center justify-center text-primary text-3xl font-bold">
                {guide.name.split(" ").map((x) => x[0]).slice(0, 2).join("")}
              </div>
              <h2 className="mt-4 text-xl font-bold text-gray-900 dark:text-white">{guide.name}</h2>
              <p className="text-sm text-gray-500 dark:text-gray-400">{guide.title}</p>

              <div className="mt-6 w-full space-y-4">
                <div className="flex justify-between items-center py-2 border-b border-gray-100 dark:border-gray-800">
                  <span className="text-sm text-gray-500 dark:text-gray-400">ID Number</span>
                  <span className="text-sm font-mono font-medium">{guide.guideId}</span>
                </div>
                <div className="flex justify-between items-center py-2 border-b border-gray-100 dark:border-gray-800">
                  <span className="text-sm text-gray-500 dark:text-gray-400">Location</span>
                  <span className="text-sm font-medium flex items-center gap-1">
                    <span className="material-icons text-xs text-primary">location_on</span>
                    {guide.location}
                  </span>
                </div>
                <div className="flex justify-between items-center py-2 border-b border-gray-100 dark:border-gray-800">
                  <span className="text-sm text-gray-500 dark:text-gray-400">Joined</span>
                  <span className="text-sm font-medium">{guide.joined}</span>
                </div>
                <div className="flex flex-col items-start gap-1 py-2">
                  <span className="text-sm text-gray-500 dark:text-gray-400">Bio</span>
                  <p className="text-sm text-gray-600 dark:text-gray-300 leading-relaxed text-left">{guide.bio}</p>
                </div>
              </div>
            </div>
          </div>

          <div className="bg-gradient-to-br from-primary/10 to-primary/5 dark:from-primary/20 dark:to-background-dark rounded-xl border border-primary/20 p-6 relative overflow-hidden">
            <div className="absolute top-0 right-0 p-4 opacity-10">
              <span className="material-icons text-9xl text-primary rotate-12 translate-x-4 -translate-y-4">verified</span>
            </div>
            <div className="relative z-10">
              <h3 className="text-xs font-semibold uppercase tracking-wider text-primary mb-4">Badge Preview</h3>
              <div className="bg-white dark:bg-gray-800/80 rounded-lg p-4 shadow-lg border border-white/20 flex items-center gap-4">
                <div className="h-12 w-12 rounded-full bg-primary flex items-center justify-center text-white shrink-0">
                  <span className="material-icons">verified_user</span>
                </div>
                <div>
                  <p className="font-bold text-gray-900 dark:text-white">Verified Guide</p>
                  <p className="text-xs text-gray-500 dark:text-gray-300">Valid until Oct 2024</p>
                </div>
                <span className="ml-auto h-2 w-2 rounded-full bg-green-500 animate-pulse" />
              </div>
              <p className="mt-4 text-xs text-gray-500 dark:text-gray-400">
                This badge will be displayed on the guide&apos;s public profile upon approval.
              </p>
            </div>
          </div>

          <div className="bg-white dark:bg-surface-darker rounded-xl border border-gray-200 dark:border-gray-800 p-6 shadow-sm">
            <h3 className="text-sm font-semibold text-gray-900 dark:text-white mb-4">Contact Details</h3>
            <ul className="space-y-3">
              <li className="flex items-center gap-3 text-sm text-gray-600 dark:text-gray-300">
                <span className="material-icons text-gray-400 text-lg">email</span>
                {guide.email}
              </li>
              <li className="flex items-center gap-3 text-sm text-gray-600 dark:text-gray-300">
                <span className="material-icons text-gray-400 text-lg">phone</span>
                {guide.phone}
              </li>
              <li className="flex items-center gap-3 text-sm text-gray-600 dark:text-gray-300">
                <span className="material-icons text-gray-400 text-lg">language</span>
                {guide.website}
              </li>
            </ul>
          </div>
        </div>

        {/* RIGHT */}
        <div className="lg:col-span-8 space-y-6">
          <div className="bg-white dark:bg-surface-darker rounded-xl border border-gray-200 dark:border-gray-800 shadow-sm overflow-hidden min-h-[600px] flex flex-col">
            <div className="flex border-b border-gray-200 dark:border-gray-800 bg-gray-50 dark:bg-surface-dark">
              <button className="px-6 py-4 text-sm font-medium text-primary border-b-2 border-primary bg-white dark:bg-surface-darker flex items-center gap-2">
                <span className="material-icons text-lg">badge</span>
                NIC
              </button>
              <button className="px-6 py-4 text-sm font-medium text-gray-500 dark:text-gray-400 hover:text-gray-700 dark:hover:text-gray-200 hover:bg-gray-100 dark:hover:bg-gray-800/50 flex items-center gap-2">
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


              <div className="relative shadow-2xl rounded bg-white max-w-full max-h-full transition-transform duration-200 ease-in-out hover:scale-[1.02] cursor-zoom-in">
                {/* Replace with real doc URL later */}
                <img
                  alt="Government ID Scan"
                  className="max-h-[500px] w-auto object-contain rounded border border-gray-200 dark:border-gray-700"
                  src="https://images.unsplash.com/photo-1521791136064-7986c2920216?q=80&w=1400&auto=format&fit=crop"
                />
              </div>
            </div>

            <div className="bg-white dark:bg-surface-darker border-t border-gray-200 dark:border-gray-800 p-4 flex items-center justify-between text-xs text-gray-500 dark:text-gray-400">
              <div className="flex items-center gap-4">
                <span>
                  Filename: <strong>ID_SCAN_FRONT.jpg</strong>
                </span>
                <span>
                  Size: <strong>2.4 MB</strong>
                </span>
                <span>
                  Uploaded: <strong>2 days ago</strong>
                </span>
              </div>
              <button className="text-primary hover:opacity-80 flex items-center gap-1 font-medium">
                <span className="material-icons text-sm">download</span> Download Original
              </button>
            </div>
          </div>

          <div className="bg-white dark:bg-surface-darker rounded-xl border border-gray-200 dark:border-gray-800 p-6 shadow-lg sticky bottom-6">
            <div className="flex flex-col md:flex-row items-start md:items-center justify-between gap-4">
              <div className="flex-grow w-full md:w-auto">
                <div className="relative">
                  <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                    <span className="material-icons text-gray-400">edit_note</span>
                  </div>
                  <input
                    className="block w-full pl-10 pr-3 py-2 border border-gray-300 dark:border-gray-700 rounded-lg bg-gray-50 dark:bg-gray-800 text-gray-900 dark:text-white placeholder-gray-500 focus:ring-1 focus:ring-primary focus:border-primary text-sm"
                    placeholder="Add optional note for rejection or approval..."
                    type="text"
                  />
                </div>
              </div>

              <div className="flex items-center gap-3 w-full md:w-auto">
                <button className="flex-1 md:flex-none justify-center px-4 py-2 border border-red-200 dark:border-red-900/50 text-red-600 dark:text-red-400 bg-red-50 dark:bg-red-900/10 hover:bg-red-100 dark:hover:bg-red-900/20 rounded-lg text-sm font-medium flex items-center gap-2">
                  <span className="material-icons text-lg">close</span>
                  Reject
                </button>
                <button className="flex-1 md:flex-none justify-center px-6 py-2 border border-transparent text-white bg-primary hover:opacity-90 rounded-lg text-sm font-medium shadow-sm flex items-center gap-2">
                  <span className="material-icons text-lg">check_circle</span>
                  Approve &amp; Issue Badge
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
