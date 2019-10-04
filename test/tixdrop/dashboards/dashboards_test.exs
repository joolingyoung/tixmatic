defmodule Tixdrop.DashboardsTest do
  use Tixdrop.DataCase

  alias Tixdrop.Dashboards

  describe "dashboards" do
    alias Tixdrop.Dashboards.Dashboard

    @valid_attrs %{}
    @invalid_attrs %{}

    def dashboard_fixture(attrs \\ %{}) do

      {:ok, dashboard} =
        attrs
        |> Enum.into(%{workspace_id: insert(:workspace).id})
        |> Enum.into(@valid_attrs)
        |> Dashboards.create_dashboard()

      dashboard
    end

    test "get_dashboard!/1 returns the dashboard with given id" do
      dashboard = dashboard_fixture()
      assert Dashboards.get_dashboard!(dashboard.id) == dashboard
    end

    test "create_dashboard/1 with valid data creates a dashboard" do
      attrs = Map.put(@valid_attrs, :workspace_id, insert(:workspace).id)
      assert {:ok, %Dashboard{} = dashboard} = Dashboards.create_dashboard(attrs)
    end

    test "create_dashboard/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Dashboards.create_dashboard(@invalid_attrs)
    end

    test "delete_dashboard/1 deletes the dashboard" do
      dashboard = dashboard_fixture()
      assert {:ok, %Dashboard{}} = Dashboards.delete_dashboard(dashboard)
      assert_raise Ecto.NoResultsError, fn -> Dashboards.get_dashboard!(dashboard.id) end
    end

    test "get_workspace_dashboard!/1 returns the dashboard with the given workspace id" do
      dashboard = dashboard_fixture()
      assert Dashboards.get_workspace_dashboard!(dashboard.workspace_id) == dashboard
    end
  end
end
