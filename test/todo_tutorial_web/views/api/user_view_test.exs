defmodule TodoTutorialWeb.Api.UserViewTest do
  use TodoTutorialWeb.ConnCase

  alias TodoTutorialWeb.Api.UserView

  @user_attrs %{
    name: "some user name",
    id: 1
  }

  describe "render" do
    test "index users json" do
      assert UserView.render("index.json", %{users: [@user_attrs]}) == %{data: [@user_attrs]}
    end

    test "show user json" do
      assert UserView.render("show.json", %{user: @user_attrs}) == %{data: @user_attrs}
    end

    test "user json" do
      assert UserView.render("user.json", %{user: @user_attrs}) == @user_attrs
    end
  end
end
  