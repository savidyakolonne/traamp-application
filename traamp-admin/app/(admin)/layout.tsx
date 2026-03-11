import Sidebar from "@/components/admin/Sidebar";
import Topbar from "@/components/admin/Topbar";

export default function AdminLayout({ children }: { children: React.ReactNode }) {
  return (
    <div className="min-h-screen flex overflow-hidden">
      <Sidebar />
      <main className="flex-1 ml-64 min-h-screen flex flex-col">
        <Topbar />
        <div className="flex-1 p-8 overflow-y-auto">{children}</div>
      </main>
    </div>
  );
}
