defmodule TixdropWeb.DashboardController do
  use TixdropWeb, :controller

  alias Tixdrop.Dashboards
  alias Tixdrop.Dashboards.Dashboard

  def show(%Plug.Conn{assigns: %{current_user: user}} = conn, %{"workspace_id" => workspace_id}) do
    dashboard = Dashboards.get_workspace_dashboard!(workspace_id)
    render(conn, "show.html", dashboard: dashboard, user: user)
  end
end
