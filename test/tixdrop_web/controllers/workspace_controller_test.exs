defmodule TixdropWeb.WorkspaceControllerTest do
  use TixdropWeb.ConnCase
  import TixdropWeb.AuthCase

  describe "show" do
    setup [:create_workspace]
    test "redirects to dashboard", %{conn: conn, workspace: workspace, user: user} do
      conn = conn |> add_session(user) |> send_resp(:ok, "/")
      conn = get(conn, Routes.workspace_path(conn, :show, workspace))
      assert conn.status == 302
      assert redirected_to(conn) == Routes.workspace_dashboard_path(conn, :show, workspace)
    end
  end

  defp create_workspace(%{conn: conn}) do
    conn = conn |> bypass_through(TixdropWeb.Router, [:browser]) |> get("/")
    user = insert(:user)
    {:ok, %{dashboard: dashboard, member: member, workspace: workspace}} = Tixdrop.WorkspaceCreation.construct_workspace(user)
    {:ok, conn: conn, dashboard: dashboard, user: user, workspace: workspace}
  end
end
