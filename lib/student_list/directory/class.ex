defmodule StudentList.Directory.Class do
  use Ecto.Schema
  import Ecto.Changeset

  schema "classes" do
    field :display_order, :integer
    field :name, :string
    field :teacher, :string

    timestamps()
  end

  @doc false
  def changeset(class, attrs) do
    class
    |> cast(attrs, [:name, :teacher, :display_order])
    |> validate_required([:name, :teacher, :display_order])
  end
end
