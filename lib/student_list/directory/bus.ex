defmodule StudentList.Directory.Bus do
  use Ecto.Schema
  import Ecto.Changeset

  schema "buses" do
    field :display_order, :integer
    field :name, :string
    field :should_display, :boolean, default: false

    timestamps()
  end

  @doc false
  def changeset(bus, attrs) do
    bus
    |> cast(attrs, [:name, :display_order, :should_display])
    |> validate_required([:name, :display_order, :should_display])
  end
end
