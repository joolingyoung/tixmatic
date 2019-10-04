defmodule Tixdrop.Workspaces.Workspace do
  use Ecto.Schema
  import Ecto.Changeset

  alias Tixdrop.Workspaces.Member
  alias Tixdrop.Dashboards.Dashboard

  schema "workspaces" do
    has_many(:members, Member)
    has_one(:dashboard, Dashboard)

    timestamps()
  end

  @doc false
  def changeset(workspace, attrs) do
    workspace
    |> cast(attrs, [])
    |> validate_required([])
  end
end
