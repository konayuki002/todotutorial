defmodule TodoTutorialWeb.Api.TaskControllerTest do
  use TodoTutorialWeb.ConnCase

  alias TodoTutorial.Todo
  alias TodoTutorial.Todo.Task

  @user_attrs %{
    name: "some user name"
  }
  @create_attrs %{
    name: "some name",
    deadline: ~N[2020-12-12 10:43:12]
  }
  @update_attrs %{
    name: "some update name",
    deadline: ~N[2020-12-24 10:43:12]
  }
  @invalid_attrs %{name: nil}

  def fixture(:task) do
    {:ok, user} = TodoTutorial.Accounts.create_user(@user_attrs)
    attrs = Map.put(@create_attrs, :user_id, user.id)
    {:ok, task} = Todo.create_task(attrs)
    task
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all tasks", %{conn: conn} do
      conn = get(conn, Routes.api_task_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create task" do
    test "renders task when data is valid", %{conn: conn} do
      {:ok, user} = TodoTutorial.Accounts.create_user(@user_attrs)
      attrs = Map.put(@create_attrs, :user_id, user.id)
      conn = post(conn, Routes.api_task_path(conn, :create), task: attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.api_task_path(conn, :show, id))

      assert %{
               "id" => id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.api_task_path(conn, :create), task: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update task" do
    setup [:create_task]

    test "renders task when data is valid", %{conn: conn, task: %Task{id: id} = task} do
      conn = put(conn, Routes.api_task_path(conn, :update, task), task: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.api_task_path(conn, :show, id))

      assert %{
               "id" => id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, task: task} do
      conn = put(conn, Routes.api_task_path(conn, :update, task), task: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete task" do
    setup [:create_task]

    test "deletes chosen task", %{conn: conn, task: task} do
      conn = delete(conn, Routes.api_task_path(conn, :delete, task))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.api_task_path(conn, :show, task))
      end
    end
  end

  defp create_task(_) do
    task = fixture(:task)
    {:ok, task: task}
  end
end
