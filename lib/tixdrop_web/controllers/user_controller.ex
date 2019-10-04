defmodule TixdropWeb.UserController do
  use TixdropWeb, :controller

  import TixdropWeb.Authorize

  alias Phauxth.Log
  alias Tixdrop.{Accounts, Accounts.User, Workspaces}
  alias TixdropWeb.{Auth.Token, Email}

  # the following plugs are defined in the controllers/authorize.ex file
  plug :user_check when action in [:index, :show]
  plug :id_check when action in [:edit, :update, :delete]

  @spec index(Plug.Conn.t(), any()) :: Plug.Conn.t()
  def index(conn, _) do
    users = Accounts.list_users()
    render(conn, "index.html", users: users)
  end

  def thanks(conn,  %{"user_id" => user_id}) do
    user = Accounts.get_user(user_id)
    render(conn, "thanks.html", user: user, layout: {TixdropWeb.LayoutView, "user.html"})
  end

  def new(conn, _) do
    changeset = Accounts.change_user(%User{})
    render(conn, "new.html", changeset: changeset, layout: {TixdropWeb.LayoutView, "user.html"})
  end

  def create(conn, %{"user" => %{"email" => email} = user_params}) do
    key = Token.sign(%{"email" => email})
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        Log.info(%Log{user: user.id, message: "user created"})

        Email.confirm_request(email, key)
        Log.info(%Log{user: user.id, message: "confirm request created for #{email}"})

        conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: Routes.user_thanks_path(conn, :thanks, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset, layout: {TixdropWeb.LayoutView, "user.html"})
    end
  end

  def show(%Plug.Conn{assigns: %{current_user: user}} = conn, %{"id" => id}) do
    user = if id == to_string(user.id), do: user, else: Accounts.get_user(id)
    render(conn, "show.html", user: user)
  end

  def edit(%Plug.Conn{assigns: %{current_user: user}} = conn, _) do
    changeset = Accounts.change_user(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(%Plug.Conn{assigns: %{current_user: user}} = conn, %{"user" => user_params}) do
    case Accounts.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: Routes.user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(%Plug.Conn{assigns: %{current_user: user}} = conn, _) do
    # First delete the users workspace and there membership.
    workspace = Workspaces.get_first_workspace_for_user_id(user.id)
    if (workspace != nil) do
      Workspaces.delete_members(workspace)
      {:ok, _member} = Workspaces.delete_workspace(workspace)
    end
    {:ok, _user} = Accounts.delete_user(user)

    conn
    |> delete_session(:phauxth_session_id)
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: Routes.session_path(conn, :new))
  end
end
