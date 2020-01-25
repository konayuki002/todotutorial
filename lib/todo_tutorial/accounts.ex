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

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    remaining_query =
      Task
      |> where([t], not t.is_finished)
    |> group_by([t], t.user_id)
    |> select([t], %{user_id: t.user_id, remaining: count(t.id)})

    finished_query = Task
    |> where([t], t.is_finished)
    |> group_by([t], t.user_id)
    |> select([t], %{user_id: t.user_id, finished: count(t.id)})

    User
    |> join(:left, [u], t in subquery(remaining_query), on: u.id == t.user_id)
    |> join(:left, [u], t2 in subquery(finished_query), on: u.id == t2.user_id)
    |> select([u, t, t2], %User{id: u.id, name: u.name, remaining: fragment("(CASE ? WHEN NULL THEN 0 ELSE ? END)", t.remaining, t.remaining), finished: t2.finished})
    |> Repo.all
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id) do
    sub = 
    Task
    |> where([t], not t.is_finished)

    User
    |> join(:left, [u], t in subquery(sub), on: u.id == t.user_id)
    |> group_by([u], u.id)
    |> select_merge([u, v], %{remaining: count(v.id)})
    |> Repo.get!(id)
  end
  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end
end
