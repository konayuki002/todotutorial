defmodule TodoTutorial.Repo.Migrations.AlterUsers2 do
  use Ecto.Migration

  def change do
    alter table("users") do
      add :unfinished, :integer, virtual: true
    end
  end
end
