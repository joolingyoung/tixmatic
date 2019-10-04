defmodule TixdropWeb.PageController do
  use TixdropWeb, :controller

  plug :put_layout, "landing.html"

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
