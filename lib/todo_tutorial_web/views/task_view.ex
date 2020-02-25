defmodule TodoTutorialWeb.TaskView do
  use TodoTutorialWeb, :view
  @moduledoc false

  @doc """
  Returns true if the user_id is selected in params.
  The answer is depends on the "user_id" in @conn[params]

  ## Examples

      iex> @conn[params]["user_id"] = "nil"
      ...> is_selected(@conn, "nil")
      true

      iex> @conn[params]["user_id"] = "2"
      ...> is_selected(@conn, 2)
      true

      iex> is_selected(@conn, "nil")
      true

      iex> is_selected(@conn, 2)
      false

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
