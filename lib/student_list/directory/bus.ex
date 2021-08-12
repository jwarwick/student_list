defmodule StudentList.Directory.Bus do
  @moduledoc """
  Bus resource
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias StudentList.Directory.Student

  schema "buses" do
    field :display_order, :integer
    field :name, :string
    field :should_display, :boolean, default: false
    has_many :students, Student

    timestamps()
  end

  @doc false
  def changeset(bus, attrs) do
    bus
    |> cast(attrs, [:name, :display_order, :should_display])
    |> validate_required([:name, :display_order, :should_display])
  end
end
