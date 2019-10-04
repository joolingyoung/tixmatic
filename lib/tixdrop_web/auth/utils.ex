defmodule TixdropWeb.Auth.Utils do
  @moduledoc """
  Helper functions for authentication.
  """

  alias Tixdrop.Sessions
  alias Tixdrop.Accounts.User

  @doc """
  Adds session data to the database.

  This function is used by Phauxth.Remember.
  """
  def create_session(%Plug.Conn{assigns: %{current_user: %{id: user_id}}}) do
    Sessions.create_session(%{user_id: user_id})
  end


  @doc """
  Indicates of the user has been confirmed.
  """
  def is_confirmed(%User{} = user) do
    user.confirmed_at != nil
  end
end
