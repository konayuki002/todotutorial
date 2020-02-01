defmodule TodoTutorial.TodoTest do
  use TodoTutorial.DataCase

  alias TodoTutorial.Todo
  doctest Todo

  describe "tasks" do
    alias TodoTutorial.Todo.Task

    @valid_attrs %{finished_at: ~N[2010-04-17 14:00:00], is_finished: true, name: "some name"}
    @update_attrs %{
      finished_at: ~N[2011-05-18 15:01:01],
      is_finished: false,
      name: "some updated name"
    }
    @urgent_attrs %{
      finished_at: ~N[2111-05-18 15:01:01],
      is_finished: false,
      name: "some urgent name"
    }
    @expired_attrs %{
      finished_at: ~N[2011-05-18 15:01:01],
      is_finished: false,
      name: "some expired name"
    }
    @invalid_attrs %{finished_at: nil, is_finished: nil, name: nil}

    def task_fixture(attrs \\ %{}) do
      {:ok, task} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Todo.create_task()

      task
    end

    test "list_tasks/0 returns all tasks" do
      task = task_fixture()
      assert Todo.list_tasks() == [task]
    end

    test "fetch_urgent_tasks/0 returns unfinished and still effective tasks" do
      assert {:ok, %Task{} = task} = Todo.create_task(task, @urgent_attrs)
      assert Todo.fetch_urgent_tasks() == [task]
    end

    test "fetch_expired_tasks/0 returns unfinished and expired tasks" do
      assert {:ok, %Task{} = task} = Todo.create_task(task, @expired_attrs)
      assert Todo.fetch_expired_tasks() == [task]
    end

    test "get_task!/1 returns the task with given id" do
      task = task_fixture()
      assert Todo.get_task!(task.id) == task
    end

    test "create_task/1 with valid data creates a task" do
      assert {:ok, %Task{} = task} = Todo.create_task(@valid_attrs)
      assert task.finished_at == ~N[2010-04-17 14:00:00]
      assert task.is_finished == true
      assert task.name == "some name"
    end

    test "create_task/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Todo.create_task(@invalid_attrs)
    end

    test "update_task/2 with valid data updates the task" do
      task = task_fixture()
      assert {:ok, %Task{} = task} = Todo.update_task(task, @update_attrs)
      assert task.finished_at == ~N[2011-05-18 15:01:01]
      assert task.is_finished == false
      assert task.name == "some updated name"
    end

    test "update_task/2 with invalid data returns error changeset" do
      task = task_fixture()
      assert {:error, %Ecto.Changeset{}} = Todo.update_task(task, @invalid_attrs)
      assert task == Todo.get_task!(task.id)
    end

    test "delete_task/1 deletes the task" do
      task = task_fixture()
      assert {:ok, %Task{}} = Todo.delete_task(task)
      assert_raise Ecto.NoResultsError, fn -> Todo.get_task!(task.id) end
    end

    test "change_task/1 returns a task changeset" do
      task = task_fixture()
      assert %Ecto.Changeset{} = Todo.change_task(task)
    end
  end
end
