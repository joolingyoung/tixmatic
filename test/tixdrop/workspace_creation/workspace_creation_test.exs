defmodule Tixdrop.WorkspaceCreationTest do
  use Tixdrop.DataCase

  alias Tixdrop.WorkspaceCreation
  alias Tixdrop.Workspaces

  describe "construct_workspace/1" do
    test "construct_workspace/1 returns workspace, member, and other if the user is valid" do
      user = insert(:user)

      assert {:ok, %{dashboard: dashboard, member: member, workspace: workspace}} =
        WorkspaceCreation.construct_workspace(user)

      workspace_from_db = Workspaces.get_first_workspace_for_user_id(user.id)

      assert workspace == workspace_from_db
      assert dashboard.workspace_id == workspace_from_db.id
      assert member.user_id == user.id
      assert member.workspace_id == workspace_from_db.id
    end

    test "constuct_workspace/1 with invalid user returns errors" do
      user = build(:user)

      assert {:error, :member, _failed_value, _changes_so_far} =
        WorkspaceCreation.construct_workspace(user)
    end
  end

  describe "get_workspace/1" do
    test "gets the workspace if it exists" do
      user = insert(:user)
      {:ok, %{workspace: workspace}} = WorkspaceCreation.construct_workspace(user)
      assert WorkspaceCreation.get_workspace(user) == workspace
    end
    test "creates the workspace if it does not" do
      user = insert(:user)
      assert WorkspaceCreation.get_workspace(user) != nil
    end
  end

end
