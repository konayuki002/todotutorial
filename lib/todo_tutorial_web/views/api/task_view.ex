defmodule TodoTutorialWeb.Api.TaskView do
  use TodoTutorialWeb, :view
  alias TodoTutorialWeb.Api.TaskView

  @doc """
    return task list json
  """
  def render("index.json", %{tasks: tasks}) do
    %{data: render_many(tasks, TaskView, "task.json")}
  end

  @doc """
    return urgent and expired tasks json
  """
  def render("urgent.json", %{urgent_tasks: urgent_tasks, expired_tasks: expired_tasks}) do
    %{
      data: %{
        urgent_tasks: render_many(urgent_tasks, TaskView, "task.json"),
        expired_tasks: render_many(expired_tasks, TaskView, "task.json")
      }
    }
  end

  @doc """
    return one task json
  """
  def render("show.json", %{task: task}) do
    %{data: render_one(task, TaskView, "task.json")}
  end

  @doc """
    return task map
  """
  def render("task.json", %{task: task}) do
    %{
      id: task.id,
      name: task.name,
      is_finished: task.is_finished,
      finished_at: task.finished_at,
      deadline: task.deadline,
      user: TodoTutorialWeb.Api.UserView.render("user.json", %{user: task.user})
    }
  end
end
