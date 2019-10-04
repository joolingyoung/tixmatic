defmodule TixdropWeb.WorkspaceController do
  use TixdropWeb, :controller

  import TixdropWeb.Authorize

  alias Tixdrop.Workspaces

  # # need to add authorization...
  # plug :workspace_check

  def show(conn, %{"id" => id}) do
    workspace = Workspaces.get_workspace!(id)
    redirect(conn, to: Routes.workspace_dashboard_path(conn, :show, workspace))
  end
end
