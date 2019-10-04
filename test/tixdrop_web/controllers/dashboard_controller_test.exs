defmodule TixdropWeb.DashboardControllerTest do
  use TixdropWeb.ConnCase
  import TixdropWeb.AuthCase

  describe "show" do
    setup [:create_dashboard]
    test "renders the dashboard when data is valid", %{conn: conn, dashboard: dashboard, user: user, workspace: workspace} do

      conn = conn |> add_session(user) |> send_resp(:ok, "/")
      conn = get(conn, Routes.workspace_dashboard_path(conn, :show, workspace))
      assert html_response(conn, 200) =~ "Dashboard"
    end
  end

  defp create_dashboard(%{conn: conn}) do
    conn = conn |> bypass_through(TixdropWeb.Router, [:browser]) |> get("/")
    user = insert(:user)
    {:ok, %{dashboard: dashboard, member: member, workspace: workspace}} = Tixdrop.WorkspaceCreation.construct_workspace(user)
    {:ok, conn: conn, dashboard: dashboard, user: user, workspace: workspace}
  end
end
