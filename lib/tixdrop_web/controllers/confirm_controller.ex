defmodule TixdropWeb.ConfirmController do
  use TixdropWeb, :controller

  alias Phauxth.Log
  alias Phauxth.Confirm
  alias Tixdrop.Accounts
  alias TixdropWeb.{Auth.Token, Email}

  plug :put_layout, "user.html"

  def new(conn, %{"email" => email}) do
    render(conn, "new.html", email: email)
  end

  def create(conn, %{"confirm" => %{"email" => email}}) do
    if Accounts.get_by(%{"email" => email}) do
      key = Token.sign(%{"email" => email})
      Email.confirm_request(email, key)
      Log.info(%Log{user: nil, message: "confirm request created for #{email}"})
    end
    conn
    |> put_flash(:info, "Check your inbox for instructions on how to confirm your account")
    |> redirect(to: Routes.page_path(conn, :index))
  end

  def index(conn, params) do
    case Confirm.verify(params) do
      {:ok, user} ->
        Accounts.confirm_user(user)
        Email.confirm_success(user.email)

        # Successful confirmation of the user's email account
        # triggers the creation of their workspace.
        Tixdrop.WorkspaceCreation.get_workspace(user)

        conn
        |> put_flash(:info, "Your account has been confirmed")
        |> redirect(to: Routes.session_path(conn, :new))

      {:error, message} ->
        conn
        |> put_flash(:error, message)
        |> redirect(to: Routes.session_path(conn, :new))
    end
  end
end
