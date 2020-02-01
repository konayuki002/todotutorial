defmodule TodoTutorial.Todo do
  @moduledoc """
  The Todo context.
  """

  import Ecto.Query, warn: false
  alias TodoTutorial.Repo

  alias TodoTutorial.Todo.Task

  @doc """
  Returns the list of tasks.

  ## Examples

      iex> list_tasks()
      [%Task{}, ...]

  """
  def list_tasks do
    Task
    |> preload(:user)
    |> Repo.all()
  end

  defp do_fetch_tasks(task_query) do
    task_query
    |> preload(:user)
    |> order_by([t], t.deadline)
    |> Repo.all()
  end

  @doc """
  Returns the list of tasks unfinished, not expired and ordered from near to distant.

  ## Examples

      iex> fetch_urgent_tasks()
      [%Task{}, ...]

  """
  @spec fetch_urgent_tasks() :: %{}
  def fetch_urgent_tasks do
    Task
    |> where([t], not t.is_finished and t.deadline > from_now(0, "second"))
    |> do_fetch_tasks()
  end

  @doc """
  Returns the list of tasks unfinished, expired and ordered from near to distant.

  ## Examples

      iex> fetch_expired_tasks()
      [%Task{}, ...]

  """
  @spec fetch_expired_tasks() :: %{}
  def fetch_expired_tasks do
    Task
    |> where([t], not t.is_finished and t.deadline < from_now(0, "second"))
    |> do_fetch_tasks()
  end

  @doc """
  Gets a single task.

  Raises `Ecto.NoResultsError` if the Task does not exist.

  ## Examples

      iex> get_task!(123)
      %Task{}

      iex> get_task!(456)
      ** (Ecto.NoResultsError)

  """
  def get_task!(id),
    do:
      Task
      |> preload(:user)
      |> Repo.get!(id)

  @doc """
  Creates a task.

  ## Examples

      iex> create_task(%{field: value})
      {:ok, %Task{}}

      iex> create_task(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_task(attrs \\ %{}) do
    %Task{}
    |> Task.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a task.

  ## Examples

      iex> update_task(task, %{field: new_value})
      {:ok, %Task{}}

      iex> update_task(task, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_task(%Task{} = task, attrs) do
    task
    |> Task.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Task.

  ## Examples

      iex> delete_task(task)
      {:ok, %Task{}}

      iex> delete_task(task)
      {:error, %Ecto.Changeset{}}

  """
  def delete_task(%Task{} = task) do
    Repo.delete(task)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking task changes.

  ## Examples

      iex> change_task(task)
      %Ecto.Changeset{source: %Task{}}

  """
  def change_task(%Task{} = task) do
    Task.changeset(task, %{})
  end
end
