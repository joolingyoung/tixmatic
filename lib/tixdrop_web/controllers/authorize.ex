defmodule TixdropWeb.Authorize do
  @moduledoc """
  Functions to help with authorization.

  See the [Authorization wiki page](https://github.com/riverrun/phauxth/wiki/Authorization)
  for more information and examples about authorization.
  """

  import Plug.Conn
  import Phoenix.Controller

  alias TixdropWeb.Router.Helpers, as: Routes
  alias Tixdrop.WorkspaceCreation

  @doc """
  Plug to only allow authenticated users to access the resource.

  See the user controller for an example.
  """
  def user_check(%Plug.Conn{assigns: %{current_user: nil}} = conn, _opts) do
    need_login(conn)
  end

  def user_check(conn, _opts), do: conn

  @doc """
  Plug to only allow unauthenticated users to access the resource.

  See the session controller for an example.
  """
  def guest_check(%Plug.Conn{assigns: %{current_user: nil}} = conn, _opts), do: conn

  def guest_check(%Plug.Conn{assigns: %{current_user: current_user}} = conn, _opts) do
    # If the user is signed in and confirmed
    # Send them to their workspace
    if !TixdropWeb.Auth.Utils.is_confirmed(current_user) do
      conn
      |> put_flash(:error, "Email must be confirmed before continuing.")
      |> redirect(to: Routes.confirm_path(conn, :new, email: current_user.email))
      |> halt()
    else
      workspace = Tixdrop.WorkspaceCreation.get_workspace(current_user)

      conn
      |> put_flash(:info, "Welcome back #{current_user.email}!")
      |> redirect(to: Routes.workspace_path(conn, :show, workspace))
      |> halt()
    end
  end

  @doc """
  Plug to allow only authenticated users who are memebers of a workspace access to the resouce.
  """
  def workspace_check(%Plug.Conn{assigns: %{current_user: nil}} = conn, _opts) do
    need_login(conn)
  end

  def workspace_check(
        %Plug.Conn{
          params: %{"workspace_id" => workspace_id},
          assigns: %{current_user: user}
        } = conn,
        _opts
      ) do
    do_workspace_check(conn, user, workspace_id)
  end

  def workspace_check(
        %Plug.Conn{
          params: %{"id" => workspace_id},
          assigns: %{current_user: user}
        } = conn,
        _opts
      ) do
    do_workspace_check(conn, user, workspace_id)
  end

  defp do_workspace_check(conn, user, workspace_id) do
    # If this isn't the users workspace, redirect back to theirs.
    workspace = WorkspaceCreation.get_workspace(user)

    if(workspace_id == to_string(workspace.id)) do
      conn
    else
      conn
      |> put_flash(:error, "You are not authorized to view that page")
      |> redirect(to: Routes.workspace_path(conn, :show, workspace))
      |> halt()
    end
  end

  @doc """
  Plug to only allow authenticated users with the correct id to access the resource.

  See the user controller for an example.
  """
  def id_check(%Plug.Conn{assigns: %{current_user: nil}} = conn, _opts) do
    need_login(conn)
  end

  def id_check(
        %Plug.Conn{params: %{"id" => id}, assigns: %{current_user: current_user}} = conn,
        _opts
      ) do
    if id == to_string(current_user.id) do
      conn
    else
      conn
      |> put_flash(:error, "You are not authorized to view this page")
      |> redirect(to: Routes.user_path(conn, :show, current_user))
      |> halt()
    end
  end

  defp need_login(conn) do
    conn
    |> put_session(:request_path, current_path(conn))
    |> put_flash(:error, "You need to log in to view this page")
    |> redirect(to: Routes.session_path(conn, :new))
    |> halt()
  end
end
