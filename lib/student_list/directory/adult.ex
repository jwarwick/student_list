defmodule StudentList.Directory.Adult do
  @moduledoc """
  Adult resource
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias StudentList.Directory.Address

  schema "adults" do
    field :email, :string
    field :first_name, :string
    field :last_name, :string
    field :mobile_phone, :string
    belongs_to :address, Address

    timestamps()
  end

  def creation_changeset(adult \\ %StudentList.Directory.Adult{}, attrs) do
    adult
    |> cast(attrs, [:first_name, :last_name, :email, :mobile_phone])
  end

  @doc false
  def changeset(adult, attrs \\ %{}) do
    adult
    |> cast(attrs, [:first_name, :last_name, :email, :mobile_phone])
    |> validate_required([:first_name, :last_name])
  end
end
