defmodule StudentList.Directory.StudentAddress do
  use Ecto.Schema
  import Ecto.Changeset

  alias Ecto.Multi

  schema "students_addresses" do
    field :student_id, :id
    field :address_id, :id

    timestamps()
  end

  def creation_transaction(multi, student_ids, address_ids) do
    cross = for s <- student_ids, a <- address_ids, do: %{:student_id => s, :address_id => a}

    multi
    |> Multi.insert_all(:students_addresses, StudentList.Directory.StudentAddress, cross)
  end

  @doc false
  def changeset(student_address, attrs) do
    student_address
    |> cast(attrs, [])
    |> validate_required([])
  end
end
