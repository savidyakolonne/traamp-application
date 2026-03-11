"use client";

import { useEffect, useState } from "react";

export default function Topbar() {
  const [dateText, setDateText] = useState("");

  useEffect(() => {
    const opts: Intl.DateTimeFormatOptions = { weekday: "long", year: "numeric", month: "short", day: "numeric" };
    setDateText(new Date().toLocaleDateString("en-US", opts));
  }, []);

  return (
    <header className="h-20 bg-white dark:bg-surface-dark border-b border-gray-200 dark:border-gray-800 flex items-center justify-between px-8 sticky top-0 z-40 backdrop-blur-md bg-opacity-90 dark:bg-opacity-90">
      <div className=" w-full">
        <div className=" text-2xl">SLTDA verfication managment system</div>
      </div>

      <div className="flex items-center gap-6">
        <div className="hidden md:block text-right">
          <p className="text-sm font-medium text-gray-900 dark:text-white">Welcome back</p>
          <p className="text-xs text-gray-500 dark:text-gray-400">Today is {dateText}</p>
        </div>

        <button className="relative p-2 text-gray-400 hover:text-primary transition-colors rounded-full hover:bg-gray-100 dark:hover:bg-gray-800">
          <span className="material-icons">notifications</span>
          <span className="absolute top-1.5 right-1.5 w-2 h-2 bg-red-500 rounded-full ring-2 ring-white dark:ring-surface-dark" />
        </button>
      </div>
    </header>
  );
}
