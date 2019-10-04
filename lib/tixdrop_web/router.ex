defmodule TixdropWeb.Router do
  use TixdropWeb, :router

  import TixdropWeb.Authorize

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Phauxth.Authenticate
    plug Phauxth.Remember, create_session_func: &TixdropWeb.Auth.Utils.create_session/1
  end

  pipeline :workspace do
    plug :workspace_check
  end

  scope "/", TixdropWeb do
    pipe_through :browser

    get "/", PageController, :index

    # Accounts, Users, and Passwords. PhauxAuth.
    resources "/users", UserController do
      get "/thanks", UserController, :thanks, as: :thanks
    end

    resources "/confirm", ConfirmController, only: [:index, :new, :create]
    resources "/sessions", SessionController, only: [:new, :create, :delete]
    resources "/confirm", ConfirmController, only: [:index, :new, :create]
    resources "/password_resets", PasswordResetController, only: [:new, :create]
    get "/password_resets/edit", PasswordResetController, :edit
    put "/password_resets/update", PasswordResetController, :update
  end

  # Authorize everythign below workspaces using workspace_check
  scope "/workspaces", TixdropWeb do
    pipe_through(:browser)
    pipe_through(:workspace)

    resources "/", WorkspaceController, only: [:show] do
      resources "/dashboard", DashboardController, only: [:show], singleton: true
    end
  end

  # Enable the bamboo sent email viewer in development.
  if Mix.env() == :dev do
    forward "/sent_email", Bamboo.SentEmailViewerPlug
  end
end
