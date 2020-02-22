defmodule TodoTutorialWeb.TaskView do
  use TodoTutorialWeb, :view

  @doc """
  Returns true if the user_id is selected in params.

  ## Examples

      iex> is_selected(@conn, "2")
      true

  """
  @spec is_selected(%Plug.Conn{params: %{required(charlist) => charlist}}, charlist) :: boolean
  def is_selected(%Plug.Conn{params: %{"user_id" => user_id}}, "nil") do
    user_id == "nil"
  end

  @spec is_selected(%Plug.Conn{params: %{required(charlist) => charlist}}, charlist) :: boolean
  def is_selected(%Plug.Conn{params: %{"user_id" => user_id}}, value) do
    user_id == Integer.to_string(value)
  end

  @spec is_selected(%Plug.Conn{}, charlist) :: boolean
  def is_selected(_conn, "nil") do
    true
  end

  @spec is_selected(%Plug.Conn{}, charlist) :: boolean
  def is_selected(_conn, _value) do
    false
  end
end
