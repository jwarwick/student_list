defmodule StudentList.Directory.Address do
  use Ecto.Schema
  import Ecto.Changeset

  schema "addresses" do
    field :address1, :string
    field :address2, :string
    field :city, :string
    field :phone, :string
    field :state, :string
    field :zip, :string

    timestamps()
  end

  @doc false
  def changeset(address, attrs) do
    address
    |> cast(attrs, [:address1, :address2, :city, :state, :zip, :phone])
    |> validate_required([:address1, :city, :state, :zip, :phone])
  end
end
