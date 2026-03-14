import { render, screen } from "@testing-library/react";
import Sidebar from "@/components/admin/Sidebar";

jest.mock("next/navigation", () => ({
  usePathname: jest.fn(() => "/admin/tourists"),
}));

global.fetch = jest.fn(() =>
  Promise.resolve({
    ok: true,
    json: () => Promise.resolve([{}, {}, {}]),
  } as Response)
) as jest.Mock;

describe("Sidebar", () => {
  it("renders sidebar navigation items", async () => {
    render(<Sidebar />);

    expect(screen.getByText("Dashboard")).toBeInTheDocument();
    expect(screen.getByText("Guides Management")).toBeInTheDocument();
    expect(screen.getByText("Tourist Management")).toBeInTheDocument();
    expect(screen.getByText("Verification Queue")).toBeInTheDocument();
    expect(await screen.findByText("3")).toBeInTheDocument();
  });
});