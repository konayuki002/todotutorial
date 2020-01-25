defmodule TodoTutorial.Repo.Migrations.AlterUsersFinished do
  use Ecto.Migration

  def change do
    rename table("users"), :unfinished, to: :finished
  end
end
