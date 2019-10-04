defmodule Tixdrop.WorkspaceCreation do
  @moduledoc """
  The WorkspaceCreation context.

  This prevents the Workspace from having a depedency on its children, like the Dashboard.
  """

  import Ecto.Query, warn: false
  alias Tixdrop.Repo

  alias Ecto.Multi

  alias Tixdrop.Workspaces
  alias Tixdrop.Accounts
  alias Tixdrop.Dashboards

  @doc """
  Creates the workspace and adds the user as its member.
  Creates all of the child elements associated with the user's workspace, like the Dashboard.
  """
  def construct_workspace(%Accounts.User{} = user) do
    Multi.new()
    |> Multi.run(:workspace, fn _, _ -> Workspaces.create_workspace() end)
    |> Multi.run(:member, fn _, %{workspace: workspace} ->
      Workspaces.create_member(%{user_id: user.id, workspace_id: workspace.id})
    end)
    |> Multi.run(:dashboard, fn _, %{workspace: workspace} ->
      Dashboards.create_dashboard(%{workspace_id: workspace.id})
    end)
    |> Repo.transaction()

  end

  @doc """
  Gets the workspace for the user. Creates it if it doesn't exist.
  """
  def get_workspace(%Accounts.User{} = user) do
    workspace = Workspaces.get_first_workspace_for_user_id(user.id)
    if workspace == nil do
      {:ok, %{workspace: workspace}} = construct_workspace(user)
      workspace
    else
      workspace
    end
  end

end
