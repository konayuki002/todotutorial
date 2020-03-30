defmodule TodoTutorialWeb.Api.TaskController do
  use TodoTutorialWeb, :controller

  alias TodoTutorial.Todo
  alias TodoTutorial.Todo.Task

  action_fallback TodoTutorialWeb.FallbackController

  def index(conn, params) do
    tasks = Todo.list_tasks(params)
    render(conn, "index.json", tasks: tasks)
  end

  def fetch_urgent(conn, _params) do
    urgent_tasks = Todo.fetch_urgent_tasks()
    expired_tasks = Todo.fetch_expired_tasks()
    render(conn, "urgent.json", urgent_tasks: urgent_tasks, expired_tasks: expired_tasks)
  end

  def create(conn, %{"task" => task_params}) do
    case Todo.create_task(task_params) do
      {:ok, %Task{} = task} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", Routes.api_task_path(conn, :show, task))
        |> render("show.json", task: task)

      {:error, _} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(TodoTutorialWeb.Api.ErrorView)
        |> render("422.json", %{message: "some params can't be blank"})
    end
  end

  def show(conn, %{"id" => id}) do
    task = Todo.get_task!(id)
    render(conn, "show.json", task: task)
  end

  def update(conn, %{"id" => id, "task" => task_params}) do
    task = Todo.get_task!(id)

    case Todo.update_task(task, task_params) do
      {:ok, %Task{} = task} ->
        render(conn, "show.json", task: task)

      {:error, _} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(TodoTutorialWeb.Api.ErrorView)
        |> render("422.json", %{message: "some params can't be blank"})
    end
  end

  def delete(conn, %{"id" => id}) do
    task = Todo.get_task!(id)

    with {:ok, %Task{}} <- Todo.delete_task(task) do
      send_resp(conn, :no_content, "")
    end
  end
end
