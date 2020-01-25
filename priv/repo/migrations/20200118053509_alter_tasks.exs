defmodule TodoTutorial.Repo.Migrations.AlterTasks do
  use Ecto.Migration

  def change do
    alter table("tasks") do
      add :user_id, references(:users)
    end
  end
end
