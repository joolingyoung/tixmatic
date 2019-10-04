defmodule Tixdrop.Factory do
  use ExMachina.Ecto, repo: Tixdrop.Repo

  def workspace_factory do
    %Tixdrop.Workspaces.Workspace{

    }
  end

  def add_member(%Tixdrop.Workspaces.Workspace{} = workspace) do
    user = insert(:user)
    insert(:member, workspace: workspace, user: user)
  end


  def user_factory do
    %Tixdrop.Accounts.User{
      email: sequence(:email, &"email-#{&1}@example.com")
    }
  end

  def member_factory do
    %Tixdrop.Workspaces.Member {
      user: build(:user),
      workspace: build(:workspace)
    }
  end

  def dashboard_factory do
    %Tixdrop.Dashboards.Dashboard {
      workspace: build(:workspace)
    }
  end

end
