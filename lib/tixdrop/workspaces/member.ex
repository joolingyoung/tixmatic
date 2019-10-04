defmodule Tixdrop.Workspaces.Member do
  use Ecto.Schema
  import Ecto.Changeset

  alias Tixdrop.Workspaces.Workspace
  alias Tixdrop.Accounts.User

  schema "members" do
    belongs_to(:user, User)
    belongs_to(:workspace, Workspace)

    timestamps()
  end

  @doc false
  def changeset(member, attrs) do
    member
    |> cast(attrs, [:user_id, :workspace_id])
    |> validate_required([:user_id, :workspace_id])
  end
end
