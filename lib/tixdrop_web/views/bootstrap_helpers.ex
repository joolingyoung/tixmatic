defmodule TixdropWeb.BootstrapHelpers do
  use Phoenix.HTML

  def bs_label(form, field, opts \\ []) do
    classes =
      [Keyword.get(opts, :class) | ["control-label"]]
      |> Enum.filter(fn item -> item != nil end)
      |> Enum.join(" ")

    opts = Keyword.put(opts, :class, classes)
    label(form, field, opts)
  end

  def bs_email_input(form, field, opts \\ []) do
    bs_input(&email_input/3, form, field, opts)
  end

  def bs_password_input(form, field, opts \\ []) do
    bs_input(&password_input/3, form, field, opts)
  end

  def bs_text_input(form, field, opts \\ []) do
    bs_input(&text_input/3, form, field, opts)
  end

  def bs_url_input(form, field, opts \\ []) do
    bs_input(&url_input/3, form, field, opts)
  end

  def bs_textarea(form, field, opts \\ []) do
    bs_input(&textarea/3, form, field, opts)
  end

  @doc """
  Given a Phoenix.HTML input function (like text_input or password_input)
  and the form, field, and its opts add the 'form-control' class.
  Also add the 'is-invalid' classes if there is an error for this field.
  """
  def bs_input(input_f, form, field, opts \\ []) do
    opts = update_opts(form, field, opts)
    input_f.(form, field, opts)
  end

  # Add form-control and the is-invalid class depending on the state of the form
  # to the class portion of the opts keywords
  defp update_opts(form, field, opts) do
    # Always add form-control
    classes = ["form-control"]

    # Add is-invalid if there is an error for this field
    classes =
      case Keyword.get_values(form.errors, field) do
        [] -> classes
        _ -> ["is-invalid" | classes]
      end

    # prepend any classes passed in the opts
    # and put the classes into a space seperated string
    classes =
      [Keyword.get(opts, :class) | classes]
      |> Enum.filter(fn item -> item != nil end)
      |> Enum.join(" ")

    # put it back in the opts
    Keyword.put(opts, :class, classes)
  end
end
