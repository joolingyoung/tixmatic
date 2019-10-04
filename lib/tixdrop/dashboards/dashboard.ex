defmodule Tixdrop.Dashboards.Dashboard do
  use Ecto.Schema
  import Ecto.Changeset

  alias Tixdrop.Workspaces.Workspace

  schema "dashboards" do
    belongs_to :workspace, Workspace
    timestamps()
  end

  @doc false
  def changeset(dashboard, attrs) do
    dashboard
    |> cast(attrs, [:workspace_id])
    |> validate_required([:workspace_id])
  end
end
