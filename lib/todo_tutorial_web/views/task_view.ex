defmodule TodoTutorialWeb.TaskView do
  use TodoTutorialWeb, :view

  def is_selected(%Plug.Conn{params: %{"user_id" => user_id}}, "nil") do
    user_id == "nil"
  end

  def is_selected(%Plug.Conn{params: %{"user_id" => user_id}}, value) do
    user_id == Integer.to_string(value)
  end

  def is_selected(_conn, "nil") do
    true
  end

  def is_selected(_conn, _value) do
    false
  end
end
