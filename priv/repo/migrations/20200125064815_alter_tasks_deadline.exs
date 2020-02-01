defmodule TodoTutorial.Repo.Migrations.AlterTasksDeadline do
  use Ecto.Migration

  def change do
    alter table("tasks") do
      add :deadline, :naive_datetime
    end
  end
end
