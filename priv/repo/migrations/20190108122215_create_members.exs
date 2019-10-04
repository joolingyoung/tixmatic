defmodule Tixdrop.Repo.Migrations.CreateMembers do
  use Ecto.Migration

  def change do
    create table(:members) do
      add :user_id, references(:users, on_delete: :nothing), null: false
      # Deleting the workspace also removes all of its memberships
      add :workspace_id, references(:workspaces, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:members, [:user_id])
    create index(:members, [:workspace_id])
  end
end
