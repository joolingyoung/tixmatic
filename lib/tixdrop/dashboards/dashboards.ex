defmodule Tixdrop.Dashboards do
  @moduledoc """
  The Dashboards context.
  """

  import Ecto.Query, warn: false
  alias Tixdrop.Repo

  alias Tixdrop.Dashboards.Dashboard
  alias Tixdrop.Workspaces

  @doc """
  Gets a dashboard given the workspace_id.

  Raises `Ecto.NoResultsError` if the Dashboard does not exist.

      iex> get_workspace_dashboard!(123)
      %Dashboard{}

      iex> get_workspace_dashboard!(456)
      ** (Ecto.NoResultsError)

  """
  def get_workspace_dashboard!(workspace_id) do
    Dashboard
    |> Repo.get_by!(workspace_id: workspace_id)
  end

  @doc """
  Gets a single dashboard.

  Raises `Ecto.NoResultsError` if the Dashboard does not exist.

  ## Examples

      iex> get_dashboard!(123)
      %Dashboard{}

      iex> get_dashboard!(456)
      ** (Ecto.NoResultsError)

  """
  def get_dashboard!(id), do: Repo.get!(Dashboard, id)

  @doc """
  Creates a dashboard.

  ## Examples

      iex> create_dashboard(%{field: value})
      {:ok, %Dashboard{}}

      iex> create_dashboard(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_dashboard(attrs \\ %{}) do
    %Dashboard{}
    |> Dashboard.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Deletes a Dashboard.

  ## Examples

      iex> delete_dashboard(dashboard)
      {:ok, %Dashboard{}}

      iex> delete_dashboard(dashboard)
      {:error, %Ecto.Changeset{}}

  """
  def delete_dashboard(%Dashboard{} = dashboard) do
    Repo.delete(dashboard)
  end
end
