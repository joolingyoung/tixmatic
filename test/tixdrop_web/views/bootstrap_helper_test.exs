defmodule TixdropWeb.BootstrapHelpersTest do
  use TixdropWeb.ConnCase, async: true
  import TixdropWeb.BootstrapHelpers
  import Phoenix.HTML.Form
  import Phoenix.HTML

  setup [:create_form]

  defp create_form(%{conn: conn}) do
    form = form_for(conn, "/")
    {:ok, form: form}
  end

  describe "bs_email_input" do
    setup %{form: form} do
      [input: safe_to_string(bs_email_input(form, :foo))]
    end

    test "adds form-control class", %{input: input} do
      assert input =~ "class=\"form-control\""
    end

    test "keeps existing classes", %{form: form} do
      input = safe_to_string(bs_password_input(form, :foo, class: "hello"))
      assert input =~ "class=\"hello form-control\""
    end

    test "is correct type", %{input: input} do
      assert input =~ "type=\"email\""
    end
  end

  describe "bs_password_input" do
    setup %{form: form} do
      [input: safe_to_string(bs_password_input(form, :foo))]
    end

    test "adds form-control class", %{input: input} do
      assert input =~ "class=\"form-control\""
    end

    test "keeps existing classes", %{form: form} do
      input = safe_to_string(bs_password_input(form, :foo, class: "hello"))
      assert input =~ "class=\"hello form-control\""
    end

    test "is correct type", %{input: input} do
      assert input =~ "type=\"password\""
    end
  end

  describe "bs_text_input" do
    setup %{form: form} do
      [input: safe_to_string(bs_text_input(form, :foo))]
    end

    test "adds form-control class", %{input: input} do
      assert input =~ "class=\"form-control\""
    end

    test "keeps existing classes", %{form: form} do
      input = safe_to_string(bs_text_input(form, :foo, class: "hello"))
      assert input =~ "class=\"hello form-control\""
    end

    test "is correct type", %{input: input} do
      assert input =~ "type=\"text\""
    end
  end

  describe "bs_url_input" do
    setup %{form: form} do
      [input: safe_to_string(bs_url_input(form, :foo))]
    end

    test "adds form-control class", %{input: input} do
      assert input =~ "class=\"form-control\""
    end

    test "keeps existing classes", %{form: form} do
      input = safe_to_string(bs_url_input(form, :foo, class: "hello"))
      assert input =~ "class=\"hello form-control\""
    end

    test "is correct type", %{input: input} do
      assert input =~ "type=\"url\""
    end
  end

  describe "bs_textarea" do
    setup %{form: form} do
      [input: safe_to_string(bs_textarea(form, :foo))]
    end

    test "adds form-control class", %{input: input} do
      assert input =~ "class=\"form-control\""
    end

    test "keeps existing classes", %{form: form} do
      input = safe_to_string(bs_textarea(form, :foo, class: "hello"))
      assert input =~ "class=\"hello form-control\""
    end

    test "is correct element", %{input: input} do
      assert input =~ "<textarea"
    end
  end

  describe "bs_label" do
    setup %{form: form} do
      [label: safe_to_string(bs_label(form, :foo))]
    end

    test "adds form-control class", %{label: label} do
      assert label =~ "class=\"control-label\""
    end
  end
end
