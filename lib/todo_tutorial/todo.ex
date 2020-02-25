defmodule TodoTutorial.Todo do
  @moduledoc """
  The Todo context.
  """

  import Ecto.Query, warn: false
  alias TodoTutorial.Repo

  alias TodoTutorial.Todo.Task

  @doc """
  Returns the filtered list of tasks.

  ## Examples

      iex> list_tasks(%{is_finished: "true"})
      [%Task{}, ...]

  """
  @spec list_tasks(%{}) :: %{}
  def list_tasks(params) do
    params = format_params(params)
    Task
    |> filter_query_by_finished(params)
    |> filter_query_by_expired(params)
    |> filter_query_by_user(params)
    |> preload(:user)
    |> Repo.all()
  end

  defp filter_query_by_finished(query, %{"is_finished" => true}) do
    query
    |> where([t], t.is_finished)
  end

  defp filter_query_by_finished(query, %{"is_finished" => false}) do
    query
  end

  defp filter_query_by_expired(query, %{"is_expired" => true}) do
    query
    |> where([t], t.deadline < from_now(0, "second"))
  end

  defp filter_query_by_expired(query, %{"is_expired" => false}) do
    query
  end

  defp filter_query_by_user(query, %{"user_id" => nil}) do
    query
  end

  defp filter_query_by_user(query, %{"user_id" => user_id}) do
    query
    |> where([t], t.user_id == ^user_id)
  end

  defp format_params(params) do
    params
    |> Map.update("is_finished", false, &(&1 == "true"))
    |> Map.update("is_expired", false, &(&1 == "true"))
    |> Map.put_new("user_id", "nil")
    |> format_user_id
  end

  defp format_user_id(%{"user_id" => "nil"} = params) do
    Map.put(params, "user_id", nil)
  end

  defp format_user_id(%{"user_id" => user_id} = params) when not (user_id == "nil") do
    Map.update(params, "user_id", nil, &String.to_integer(&1))
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
