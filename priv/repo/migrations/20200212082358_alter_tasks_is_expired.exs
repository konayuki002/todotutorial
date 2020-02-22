defmodule TodoTutorial.Repo.Migrations.AlterTasksIsExpired do
  use Ecto.Migration

  def change do
    alter table("tasks") do
      add :is_expired, :boolean, virtual: true
    end
  end
end
