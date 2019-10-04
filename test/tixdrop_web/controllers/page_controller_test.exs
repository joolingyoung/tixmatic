defmodule TixdropWeb.PageControllerTest do
  use TixdropWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Your new ticket drop checker"
  end
end
