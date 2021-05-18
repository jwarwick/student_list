defmodule StudentList.Directory.Class do
  use Ecto.Schema
  import Ecto.Changeset
  alias StudentList.Directory.Student

  schema "classes" do
    field :display_order, :integer
    field :name, :string
    field :teacher, :string
    has_many :student, Student

    timestamps()
  end

  @doc false
  def changeset(class, attrs) do
    class
    |> cast(attrs, [:name, :teacher, :display_order])
    |> validate_required([:name, :teacher, :display_order])
  end
end
