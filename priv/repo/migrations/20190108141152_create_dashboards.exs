defmodule Tixdrop.Repo.Migrations.CreateDashboards do
  use Ecto.Migration

  def change do
    create table(:dashboards) do
      add :workspace_id, references(:workspaces, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:dashboards, [:workspace_id])
  end
end
