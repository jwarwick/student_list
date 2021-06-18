defmodule StudentList.Directory.Address do
  use Ecto.Schema
  import Ecto.Changeset
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

  def creation_changeset(address \\ %StudentList.Directory.Address{}, attrs) do
    IO.inspect(attrs, label: "address creation")
    address
    |> cast(attrs, [:address1, :address2, :city, :state, :zip, :phone])
  end

  @doc false
  def changeset(address, attrs) do
    address
    |> cast(attrs, [:address1, :address2, :city, :state, :zip, :phone])
  end
end
