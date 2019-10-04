defmodule TixdropWeb.LayoutViewTest do
  use TixdropWeb.ConnCase, async: true

  import Phoenix.HTML
  import TixdropWeb.LayoutView

  describe "active_link" do
    test "adds active if current path", %{conn: conn} do
      assert safe_to_string(active_link(conn, "LinkName", to: "/")) =~ "class=\"active\""
    end
    test "keeps existing classes if current path", %{conn: conn} do
      assert safe_to_string(active_link(conn, "LinkName", to: "/", class: "foo")) =~ "class=\"foo active\""
    end
    test "no class if not current path", %{conn: conn} do
      assert !(safe_to_string(active_link(conn, "LinkName", to: "/users")) =~ "class")
    end
    test "keeps existing classes if not current path", %{conn: conn} do
      assert safe_to_string(active_link(conn, "LinkName", to: "/users", class: "foo")) =~ "class=\"foo\""
    end
  end
end
