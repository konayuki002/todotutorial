defmodule TodoTutorialWeb.TaskControllerTest do
  use TodoTutorialWeb.ConnCase

  alias TodoTutorial.Todo

  @user_attrs %{name: "some user name"}

  @create_attrs %{
    finished_at: ~N[2010-04-17 14:00:00],
    is_finished: true,
    name: "some name",
    deadline: ~N[2022-01-01 15:20:20]
  }
  @update_attrs %{
    finished_at: ~N[2011-05-18 15:01:01],
    is_finished: false,
    name: "some updated name",
    deadline: ~N[2022-01-01 15:20:20]
  }
  @invalid_attrs %{finished_at: nil, is_finished: nil, name: nil}

  def fixture(:task) do
    {:ok, user} = TodoTutorial.Accounts.create_user(@user_attrs)
    attrs = Map.put(@create_attrs, :user_id, user.id)
    {:ok, task} = Todo.create_task(attrs)
    task
  end

  describe "index" do
    test "lists all tasks", %{conn: conn} do
      conn = get(conn, Routes.task_path(conn, :index))
      assert response(conn, 200)
    end
  end

  describe "new task" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.task_path(conn, :new))
      assert html_response(conn, 200) =~ "New Task"
    end
  end

  describe "create task" do
    test "redirects to show when data is valid", %{conn: conn} do
      {:ok, user} = TodoTutorial.Accounts.create_user(@user_attrs)
      attrs = Map.put(@create_attrs, :user_id, user.id)
      conn = post(conn, Routes.task_path(conn, :create), task: attrs)

      assert redirected_to(conn) == Routes.task_path(conn, :index)

      id =
        Enum.find_value(Todo.list_tasks(%{}), fn task ->
          if task.name == "some name", do: task.id
        end)

      conn = get(conn, Routes.task_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Task"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.task_path(conn, :create), task: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Task"
    end
  end

  describe "edit task" do
    setup [:create_task]

    test "renders form for editing chosen task", %{conn: conn, task: task} do
      conn = get(conn, Routes.task_path(conn, :edit, task))
      assert html_response(conn, 200) =~ "Edit Task"
    end
  end

  describe "update task" do
    setup [:create_task]

    test "redirects when data is valid", %{conn: conn, task: task} do
      conn = put(conn, Routes.task_path(conn, :update, task), task: @update_attrs)
      assert redirected_to(conn) == Routes.task_path(conn, :index)

      conn = get(conn, Routes.task_path(conn, :show, task))
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, task: task} do
      conn = put(conn, Routes.task_path(conn, :update, task), task: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Task"
    end
  end

  describe "delete task" do
    setup [:create_task]

    test "deletes chosen task", %{conn: conn, task: task} do
      conn = delete(conn, Routes.task_path(conn, :delete, task))
      assert redirected_to(conn) == Routes.task_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.task_path(conn, :show, task))
      end
    end
  end

  defp create_task(_) do
    task = fixture(:task)
    {:ok, task: task}
  end
end
