defmodule Tixdrop.Repo.Migrations.CreateWorkspaces do
  use Ecto.Migration

  def change do
    create table(:workspaces) do

      timestamps()
    end

  end
end
