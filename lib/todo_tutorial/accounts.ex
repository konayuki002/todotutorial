defmodule TodoTutorial.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias TodoTutorial.Repo

  alias TodoTutorial.Accounts.User
  alias TodoTutorial.Todo.Task

  @doc """
  Returns the list of users.
  """
  def list_users do
    make_user_task_count_query()
    |> Repo.all()
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.
  """
  def get_user!(id) do
    make_user_task_count_query()
    |> Repo.get!(id)
  end

  defp make_user_task_count_query do
    remaining_query =
      Task
      |> where([t], not t.is_finished)
      |> count_user_tasks

    finished_query =
      Task
      |> where([t], t.is_finished)
      |> count_user_tasks

    User
    |> join(:left, [u], t in subquery(remaining_query), on: u.id == t.user_id)
    |> join(:left, [u], t2 in subquery(finished_query), on: u.id == t2.user_id)
    |> select([u, t, t2], %User{
      id: u.id,
      name: u.name,
      remaining: fragment("CASE WHEN ? is NULL THEN 0 ELSE ? END", t.count, t.count),
      finished: fragment("CASE WHEN ? is NULL THEN 0 ELSE ? END", t2.count, t2.count),
      inserted_at: u.inserted_at,
      updated_at: u.updated_at
    })
  end

  defp count_user_tasks(query) do
    query
    |> group_by([t], t.user_id)
    |> select([t], %{user_id: t.user_id, count: count(t.id)})
  end

  @doc """
  Creates a user.
  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.
  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.
  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.
  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end
end
