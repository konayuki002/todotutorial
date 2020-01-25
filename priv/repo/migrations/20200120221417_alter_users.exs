defmodule TodoTutorial.Repo.Migrations.AlterUsers do
  use Ecto.Migration

  def change do
    alter table("users") do
      add :remaining, :integer, virtual: true
    end
  end
end
