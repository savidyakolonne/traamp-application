"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";
import { useEffect, useState } from "react";

type NavItem = { href: string; icon: string; label: string; badge?: string };

const items: NavItem[] = [
  { href: "/admin/dashboard", icon: "dashboard", label: "Dashboard" },
  { href: "/admin/guides", icon: "map", label: "Guides Management" },
  { href: "/admin/tourists", icon: "people", label: "Tourist Management" },
  { href: "/admin/verifications", icon: "verified_user", label: "Verification Queue" },
];

export default function Sidebar() {
  const pathname = usePathname();
  const [queueCount, setQueueCount] = useState(0);

  useEffect(() => {
  const loadCount = async () => {
    try {
      const res = await fetch(
        `${process.env.NEXT_PUBLIC_API_URL}/api/admin/verifications`
      );
      const data = await res.json();

      if (!res.ok) {
        throw new Error(data?.error || "Failed to fetch verification count");
      }

      if (Array.isArray(data)) {
        setQueueCount(data.length);
      } else {
        setQueueCount(0);
      }
    } catch (err) {
      console.error("Failed to load verification queue count:", err);
      setQueueCount(0);
    }
  };

  loadCount();
}, []);

  return (
    <aside className="w-64 bg-white dark:bg-surface-dark border-r border-gray-200 dark:border-gray-800 flex flex-col h-screen fixed left-0 top-0 z-50">
      <div className="h-20 flex items-center px-8 border-b border-gray-100 dark:border-gray-800/50">
        <div className="flex items-center gap-2 text-primary font-bold text-xl tracking-tight">
          <span className="material-icons text-3xl">explore</span>
          <span>Traamp Admin</span>
        </div>
      </div>

      <nav className="flex-1 overflow-y-auto py-6 px-4 space-y-2">
        <p className="px-4 text-xs font-semibold text-gray-400 uppercase tracking-wider">
          Main Menu
        </p>

        {items.map((it) => {
          const active =
            pathname === it.href ||
            (it.href !== "/admin/dashboard" && pathname?.startsWith(it.href));

          return (
            <Link
              key={it.href}
              href={it.href}
              className={[
                "flex items-center justify-between px-4 py-3 rounded-lg font-medium transition-colors",
                active
                  ? "bg-primary/10 text-primary"
                  : "text-gray-600 dark:text-gray-400 hover:bg-gray-50 dark:hover:bg-gray-800/50 hover:text-primary dark:hover:text-primary",
              ].join(" ")}
            >
              <span className="flex items-center gap-3">
                <span className="material-icons text-xl">{it.icon}</span>
                {it.label}
              </span>

              {it.href === "/admin/verifications" ? (
                <span className="bg-red-500 text-white text-xs font-bold px-2 py-0.5 rounded-full">
                  {queueCount}
                </span>
              ) : it.badge ? (
                <span className="bg-red-500 text-white text-xs font-bold px-2 py-0.5 rounded-full">
                  {it.badge}
                </span>
              ) : null}
            </Link>
          );
        })}

        <p className="px-4 text-xs font-semibold text-gray-400 uppercase tracking-wider mt-8">
          System
        </p>

        <Link
          href="#"
          className="flex items-center gap-3 px-4 py-3 text-gray-600 dark:text-gray-400 hover:bg-gray-50 dark:hover:bg-gray-800/50 hover:text-primary dark:hover:text-primary rounded-lg font-medium transition-colors"
        >
          <span className="material-icons text-xl">settings</span>
          Settings
        </Link>

        <Link
          href="#"
          className="flex items-center gap-3 px-4 py-3 text-gray-600 dark:text-gray-400 hover:bg-gray-50 dark:hover:bg-gray-800/50 hover:text-primary dark:hover:text-primary rounded-lg font-medium transition-colors"
        >
          <span className="material-icons text-xl">help_outline</span>
          Help Center
        </Link>
      </nav>

      <div className="p-4 border-t border-gray-100 dark:border-gray-800/50 bg-gray-50 dark:bg-surface-darker">
        <div className="flex items-center gap-3">
          <div className="w-10 h-10 rounded-full bg-primary/20 flex items-center justify-center text-primary font-bold">
            A
          </div>
          <div className="flex-1 min-w-0">
            <p className="text-sm font-semibold text-gray-900 dark:text-white truncate">
              Admin
            </p>
            <p className="text-xs text-gray-500 dark:text-gray-400 truncate">
              Super Admin
            </p>
          </div>
          <button className="text-gray-400 hover:text-primary" title="Logout">
            <span className="material-icons">logout</span>
          </button>
        </div>
      </div>
    </aside>
  );
}