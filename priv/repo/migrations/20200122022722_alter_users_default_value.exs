defmodule TodoTutorial.Repo.Migrations.AlterUsersDefaultValue do
  use Ecto.Migration

  def change do
    alter table("users") do
      modify :remaining, :integer, default: 0
      modify :finished, :integer, default: 0
    end
  end
end
