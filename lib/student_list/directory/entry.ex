defmodule StudentList.Directory.Entry do
  use Ecto.Schema
  import Ecto.Changeset
  alias Ecto.Multi
  alias StudentList.Repo

  alias StudentList.Directory.{Address, Student}

  schema "entries" do
    field :content, :string
    has_many :addresses, Address
    has_many :students, Student

    timestamps()
  end

  def creation_transaction(multi, assigns, students, addresses) do
    value = assigns
            |> Map.take([:students, :addresses, :notes])
            |> Jason.encode!()

    address_list = Enum.map(addresses, &(Repo.get(Address, &1)))
    student_list = Enum.map(students, &(Repo.get(Student, &1)))

    Multi.insert(multi, 
                 "entry",
                 %StudentList.Directory.Entry{}
                 |> Repo.preload([:students, :addresses])
                 |> cast(%{content: value}, [:content])
                 |> put_assoc(:addresses, address_list)
                 |> put_assoc(:students, student_list)
                 |> validate_required([:content]))
  end

  @doc false
  def changeset(entry, attrs) do
    entry
    |> cast(attrs, [:content])
    |> validate_required([:content])
  end
end
