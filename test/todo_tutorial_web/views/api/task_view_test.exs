defmodule TodoTutorialWeb.Api.TaskViewTest do
  use TodoTutorialWeb.ConnCase

  alias TodoTutorialWeb.Api.TaskView

  @user_attrs %{
    name: "some user name",
    id: 1
  }
  @urgent_attrs %{
    name: "some name",
    deadline: ~N[2020-12-12 10:43:12],
    is_finished: false,
    finished_at: nil,
    id: 1,
    user: @user_attrs
  }
  @expired_attrs %{
    name: "some update name",
    deadline: ~N[2020-12-24 10:43:12],
    is_finished: false,
    finished_at: nil,
    id: 2,
    user: @user_attrs
  }

  describe "render" do
    test "index tasks json" do
      assert TaskView.render("index.json", %{tasks: [@urgent_attrs]}) == %{data: [@urgent_attrs]}
    end

    test "urgent tasks json" do
      assert TaskView.render("urgent.json", %{
               urgent_tasks: [@urgent_attrs],
               expired_tasks: [@expired_attrs]
             }) == %{data: %{urgent_tasks: [@urgent_attrs], expired_tasks: [@expired_attrs]}}
    end

    test "show task json" do
      assert TaskView.render("show.json", %{task: @urgent_attrs}) == %{data: @urgent_attrs}
    end

    test "task json" do
      assert TaskView.render("task.json", %{task: @urgent_attrs}) == @urgent_attrs
    end
  end
end
