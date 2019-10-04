defmodule Tixdrop.WorkspacesTest do
  use Tixdrop.DataCase

  alias Tixdrop.Workspaces

  describe "workspaces" do
    alias Tixdrop.Workspaces.Workspace

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def workspace_fixture(attrs \\ %{}) do
      {:ok, workspace} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Workspaces.create_workspace()

      workspace
    end

    test "get_workspace!/1 returns the workspace with given id" do
      workspace = workspace_fixture()
      assert Workspaces.get_workspace!(workspace.id) == workspace
    end

    test "create_workspace/1 with valid data creates a workspace" do
      assert {:ok, %Workspace{} = workspace} = Workspaces.create_workspace(@valid_attrs)
    end

    # there is no invalid data
    #
    # test "create_workspace/1 with invalid data returns error changeset" do
    #   assert {:error, %Ecto.Changeset{}} = Workspaces.create_workspace(@invalid_attrs)
    # end

    test "delete_workspace/1 deletes the workspace" do
      workspace = workspace_fixture()
      assert {:ok, %Workspace{}} = Workspaces.delete_workspace(workspace)
      assert_raise Ecto.NoResultsError, fn -> Workspaces.get_workspace!(workspace.id) end
    end
  end

  describe "members" do
    alias Tixdrop.Workspaces.Member

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{workspace_id: nil}

    def member_fixture(attrs \\ %{}) do
      user = insert(:user)
      workspace = insert(:workspace)

      {:ok, member} =
        attrs
        |> Enum.into(%{user_id: user.id, workspace_id: workspace.id})
        |> Enum.into(@valid_attrs)
        |> Workspaces.create_member()

      member
    end

    test "list_members/0 returns all members" do
      member = member_fixture()
      assert Workspaces.list_members() == [member]
    end

    test "get_member!/1 returns the member with given id" do
      member = member_fixture()
      assert Workspaces.get_member!(member.id) == member
    end

    test "create_member/1 with valid data creates a member" do
      user = insert(:user)
      workspace = insert(:workspace)
      attrs = Enum.into(@valid_attrs, %{user_id: user.id, workspace_id: workspace.id})
      assert {:ok, %Member{} = member} = Workspaces.create_member(attrs)
    end

    test "create_member/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Workspaces.create_member(@invalid_attrs)
    end

    test "update_member/2 with valid data updates the member" do
      member = member_fixture()
      assert {:ok, %Member{} = member} = Workspaces.update_member(member, @update_attrs)
    end

    test "update_member/2 with invalid data returns error changeset" do
      member = member_fixture()
      assert {:error, %Ecto.Changeset{}} = Workspaces.update_member(member, @invalid_attrs)
      assert member == Workspaces.get_member!(member.id)
    end

    test "delete_member/1 deletes the member" do
      member = member_fixture()
      assert {:ok, %Member{}} = Workspaces.delete_member(member)
      assert_raise Ecto.NoResultsError, fn -> Workspaces.get_member!(member.id) end
    end

    test "change_member/1 returns a member changeset" do
      member = member_fixture()
      assert %Ecto.Changeset{} = Workspaces.change_member(member)
    end
  end

  describe "get_first_workspace_for_user_id/1" do
    test "gets the workspace if there is a user" do
      workspace = insert(:workspace)
      user = insert(:user)
      insert(:member, user: user, workspace: workspace)
      # Add a couple more members
      insert(:member, workspace: workspace, user: insert(:user))
      insert(:member, workspace: workspace, user: insert(:user))

      assert workspace = Workspaces.get_first_workspace_for_user_id(user.id)
    end
    test "returns nil if there is no user" do
      assert nil == Workspaces.get_first_workspace_for_user_id(11)
    end
  end
end
