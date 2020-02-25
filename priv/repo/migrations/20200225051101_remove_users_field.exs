defmodule TodoTutorial.Repo.Migrations.RemoveUsersField do
  use Ecto.Migration

  def change do
    alter table("tasks") do
      remove :is_expired
    end
  end
end
