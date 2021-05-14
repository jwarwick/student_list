defmodule StudentList.Repo.Migrations.CreateBuses do
  use Ecto.Migration

  def change do
    create table(:buses) do
      add :name, :string
      add :display_order, :integer
      add :should_display, :boolean, default: false, null: false

      timestamps()
    end
  end
end
