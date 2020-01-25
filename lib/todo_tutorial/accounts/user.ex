defmodule TodoTutorial.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :name, :string
    has_many :tasks, TodoTutorial.Todo.Task
    field :remaining, :integer, virtual: true, default: 0
    field :finished, :integer, virtual: true, default: 0
    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
