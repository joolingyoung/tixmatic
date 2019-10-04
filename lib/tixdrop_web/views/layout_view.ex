defmodule TixdropWeb.LayoutView do
  use TixdropWeb, :view

  @doc """
  If the curent path matches the path for the link, add the active class to the link element.
  """
  def active_link(conn, text, opts \\ []) do
    path = Keyword.get(opts, :to)
    class =
      if Phoenix.Controller.current_path(conn, %{}) == path do
        [Keyword.get(opts, :class), "active"]
        |> Enum.reject(fn item -> item == nil end)
        |> Enum.join(" ")
      else
        Keyword.get(opts, :class)
      end

    opts =
      if class != nil do
        Keyword.put(opts, :class, class)
      else
        opts
      end

    link(text, opts)
  end
end
