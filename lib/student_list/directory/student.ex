defmodule StudentList.Directory.Student do
  use Ecto.Schema
  import Ecto.Changeset
  alias Ecto.Multi
  alias StudentList.Directory.{Bus, Class}
  alias StudentList.Repo

  schema "students" do
    field :first_name, :string
    field :last_name, :string
    field :notes, :string
    belongs_to :bus, Bus
    belongs_to :class, Class

    timestamps()
  end

  defp get_item(type, string_id) do
    case Integer.parse(string_id) do
      {x, _} -> Repo.get(type, x)
      _ -> nil
    end
  end

  def creation_transaction(multi, idx, attrs) do
    bus = get_item(Bus, attrs["bus"])
    class = get_item(Class, attrs["classroom"])

    Multi.insert(multi, 
                 "student #{idx}",
                 %StudentList.Directory.Student{}
                 |> Repo.preload([:bus, :class])
                 |> cast(attrs, [:first_name, :last_name, :notes])
                 |> put_assoc(:bus, bus)
                 |> put_assoc(:class, class)
                 |> validate_required([:first_name]))
  end

  @doc false
  def changeset(student, attrs \\ %{}) do
    student
    |> cast(attrs, [:first_name, :last_name, :notes])
    |> validate_required([:first_name, :last_name])
  end
end
