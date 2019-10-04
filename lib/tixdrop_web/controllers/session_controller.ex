defmodule TixdropWeb.SessionController do
  use TixdropWeb, :controller

  import TixdropWeb.Authorize

  alias Phauxth.Remember
  alias Tixdrop.Sessions
  alias Tixdrop.WorkspaceCreation
  alias TixdropWeb.Auth.{Login, Utils}

  plug :put_layout, "user.html"
  plug :guest_check when action in [:new, :create]

  def new(conn, _) do
    render(conn, "new.html")
  end

  def create(conn, %{"session" => params}) do
    case Login.verify(params) do
      {:ok, user} ->
        if (Utils.is_confirmed(user)) do
          conn
          |> add_session(user, params)
          |> put_flash(:info, "User successfully logged in.")
          |> redirect(to: get_session(conn, :request_path) || Routes.workspace_path(conn, :show, WorkspaceCreation.get_workspace(user)))
        else
          conn
          |> put_flash(:error, "User email has not been confirmed.")
          |> redirect(to: Routes.confirm_path(conn, :new, email: user.email))
        end

      {:error, message} ->
        conn
        |> put_flash(:error, message)
        |> put_flash(:info, "If you have cannot remember your password, please click the 'Forgot Password' link below")
        |> redirect(to: Routes.session_path(conn, :new))
    end
  end

  def delete(%Plug.Conn{assigns: %{current_user: %{id: user_id}}} = conn, %{"id" => session_id}) do
    case session_id |> Sessions.get_session() |> Sessions.delete_session() do
      {:ok, %{user_id: ^user_id}} ->
        conn
        |> delete_session(:phauxth_session_id)
        |> Remember.delete_rem_cookie()
        |> put_flash(:info, "User successfully logged out.")
        |> redirect(to: Routes.page_path(conn, :index))

      _ ->
        conn
        |> put_flash(:error, "Unauthorized")
        |> redirect(to: Routes.user_path(conn, :index))
    end
  end

  defp add_session(conn, user, params) do
    {:ok, %{id: session_id}} = Sessions.create_session(%{user_id: user.id})

    conn
    |> delete_session(:request_path)
    |> put_session(:phauxth_session_id, session_id)
    |> configure_session(renew: true)
    |> add_remember_me(user.id, params)
  end

  # This function adds a remember_me cookie to the conn.
  # See the documentation for Phauxth.Remember for more details.
  defp add_remember_me(conn, user_id, %{"remember_me" => "true"}) do
    Remember.add_rem_cookie(conn, user_id)
  end

  defp add_remember_me(conn, _, _), do: conn
end
