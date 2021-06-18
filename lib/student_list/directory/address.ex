defmodule StudentList.Directory.Address do
  use Ecto.Schema
  import Ecto.Changeset
  alias Ecto.Multi
  alias StudentList.Directory.Adult

  schema "addresses" do
    field :address1, :string
    field :address2, :string
    field :city, :string
    field :phone, :string
    field :state, :string
    field :zip, :string
    has_many :adults, Adult

    timestamps()
  end

  def creation_transaction(multi, address_index, attrs) do
    Multi.insert(multi, 
                 "address #{address_index}",
                 %StudentList.Directory.Address{}
                 |> cast(attrs, [:address1, :address2, :city, :state, :zip, :phone])
                 |> cast_assoc(:adults, with: &Adult.creation_changeset/2)
    )
  end

  @doc false
  def changeset(address, attrs) do
    address
    |> cast(attrs, [:address1, :address2, :city, :state, :zip, :phone])
  end
end
