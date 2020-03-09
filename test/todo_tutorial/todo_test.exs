defmodule TodoTutorial.TodoTest do
  use TodoTutorial.DataCase

  alias TodoTutorial.Todo
  doctest Todo

  describe "tasks" do
    alias TodoTutorial.Todo.Task

    @user_attrs%{name: "some_user_name", id: 0}

    @valid_attrs %{finished_at: ~N[2010-04-17 14:00:00], is_finished: false, name: "some name", user_id: 0, deadline: ~N[2020-03-09 13:52:27]}
    @update_attrs %{finished_at: ~N[2011-05-18 15:01:01], is_finished: false, name: "some updated name", user_id: 0, deadline: ~N[2020-03-09 13:52:27]}
    @urgent_attrs %{finished_at: nil, is_finished: false, name: "some urgent name", user_id: 0, deadline: ~N[2345-03-09 13:52:27]}
    @expired_attrs %{finished_at: nil, is_finished: false, name: "some expired name", user_id: 0, deadline: ~N[1999-01-01 13:52:27]}
    @invalid_attrs %{finished_at: nil, is_finished: nil, name: nil, user_name: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} = 
        attrs
        |> Enum.into(@user_attrs)
        |> TodoTutorial.Accounts.create_user()
      
      user
    end
    
    def task_fixture(attrs \\ %{}) do
      {:ok, task} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Todo.create_task()

      task
    end

    test "list_tasks/0 returns all tasks" do
      user = user_fixture()
      task = task_fixture(%{user_id: user.id})
      task = %{task | user: user}
      assert Todo.list_tasks(%{}) == [task]
    end

    test "fetch_urgent_tasks/0 returns unfinished and still effective tasks" do
      user = user_fixture()
      {:ok, task} = Todo.create_task(%{@urgent_attrs | user_id: user.id})
      task = %{task | user: user}
      assert Todo.fetch_urgent_tasks() == [task]
    end

    test "fetch_expired_tasks/0 returns unfinished and expired tasks" do
      user = user_fixture()
      {:ok, task} = Todo.create_task(%{@expired_attrs | user_id: user.id})
      task = %{task | user: user}
      assert Todo.fetch_expired_tasks() == [task]
    end

    test "get_task!/1 returns the task with given id" do
      user = user_fixture()
      task = task_fixture(%{user_id: user.id})
      task = %{task | user: user}
      assert Todo.get_task!(task.id) == task
    end

    test "create_task/1 with valid data creates a task" do
      user = user_fixture()
      assert {:ok, %Task{} = task} = Todo.create_task(%{@valid_attrs | user_id: user.id})
      assert task.finished_at == nil
      assert task.is_finished == false
      assert task.name == "some name"
    end

    test "create_task/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Todo.create_task(@invalid_attrs)
    end

    test "update_task/2 with valid data updates the task" do
      user = user_fixture()
      task = task_fixture(%{user_id: user.id})
      assert {:ok, %Task{} = task} = Todo.update_task(task, %{@update_attrs | user_id: user.id})
      assert task.finished_at == nil
      assert task.is_finished == false
      assert task.name == "some updated name"
    end

    test "update_task/2 with invalid data returns error changeset" do
      user = user_fixture()
      task = task_fixture(%{user_id: user.id})
      assert {:error, %Ecto.Changeset{}} = Todo.update_task(task, @invalid_attrs)
      task = %{task | user: user}
      assert task == Todo.get_task!(task.id)
    end

    test "delete_task/1 deletes the task" do
      user = user_fixture()
      task = task_fixture(%{user_id: user.id})
      assert {:ok, %Task{}} = Todo.delete_task(task)
      assert_raise Ecto.NoResultsError, fn -> Todo.get_task!(task.id) end
    end

    test "change_task/1 returns a task changeset" do
      user = user_fixture()
      task = task_fixture(%{user_id: user.id})
      assert %Ecto.Changeset{} = Todo.change_task(task)
    end
  end
end
