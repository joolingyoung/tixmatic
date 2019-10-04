defmodule TixdropWeb.SessionHelpers do

  @doc """
  Gets the current session
  """
  def current_session(conn) do
    Plug.Conn.get_session(conn, :phauxth_session_id)
  end

end
