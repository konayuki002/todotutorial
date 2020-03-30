defmodule TodoTutorialWeb.Api.ErrorViewTest do
  use TodoTutorialWeb.ConnCase

  alias TodoTutorialWeb.Api.ErrorView

  doctest ErrorView

  describe "render" do
    test "error json" do
      assert ErrorView.render("422.json", %{message: "name can't be blank"}) == %{errors: "name can't be blank"}
    end
  end
end
    