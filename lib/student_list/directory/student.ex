defmodule StudentList.Directory.Student do
  use Ecto.Schema
  import Ecto.Changeset
  alias StudentList.Directory.{Bus, Class}

  schema "students" do
    field :first_name, :string
    field :last_name, :string
    field :notes, :string
    belongs_to :bus, Bus
    belongs_to :class, Class

    timestamps()
  end

  @doc false
  def changeset(student, attrs \\ %{}) do
    student
    |> cast(attrs, [:first_name, :last_name, :notes])
    |> validate_required([:first_name, :last_name])
  end
end
