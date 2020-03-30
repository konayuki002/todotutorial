defmodule TodoTutorialWeb.Api.ErrorView do
  use TodoTutorialWeb, :view

  @doc """
  render error json
    
  ## Examples

    iex> TodoTutorialWeb.Api.ErrorView.render("422.json", %{message: "name can't be blank"})
    %{errors: "name can't be blank"}
    
  """
  def render("422.json", %{message: message}) do
    %{errors: message}
  end
end
