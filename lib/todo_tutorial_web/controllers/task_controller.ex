defmodule TodoTutorialWeb.TaskController do
  use TodoTutorialWeb, :controller

  alias TodoTutorial.Todo
  alias TodoTutorial.Todo.Task
  alias TodoTutorial.Repo

  import Ecto.Query

  def index(conn, params) do
    tasks = Todo.list_tasks(params)
    users = TodoTutorial.Accounts.User |> order_by(asc: :name) |> Repo.all
    render(conn, "index.html", tasks: tasks, users: users)
  end

  def fetch_urgent(conn, _params) do
    urgent_tasks = Todo.fetch_urgent_tasks()
    expired_tasks = Todo.fetch_expired_tasks()
    render(conn, "urgent.html", urgent_tasks: urgent_tasks, expired_tasks: expired_tasks)
  end

  def new(conn, _params) do
    changeset = Todo.change_task(%Task{})
    users = Repo.all(TodoTutorial.Accounts.User)
    render(conn, "new.html", changeset: changeset, users: users)
  end

  def create(conn, %{"task" => task_params}) do
    case Todo.create_task(task_params) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Task created successfully.")
        |> redirect(to: Routes.task_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    task = Todo.get_task!(id)
    render(conn, "show.html", task: task)
  end

  def edit(conn, %{"id" => id}) do
    task = Todo.get_task!(id)
    changeset = Todo.change_task(task)
    users = Repo.all(TodoTutorial.Accounts.User)
    render(conn, "edit.html", task: task, changeset: changeset, users: users)
  end

  def update(conn, %{"id" => id, "task" => task_params}) do
    task = Todo.get_task!(id)

    case Todo.update_task(task, task_params) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Task updated successfully.")
        |> redirect(to: Routes.task_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", task: task, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    task = Todo.get_task!(id)
    {:ok, _task} = Todo.delete_task(task)

    conn
    |> put_flash(:info, "Task deleted successfully.")
    |> redirect(to: Routes.task_path(conn, :index))
  end
end
