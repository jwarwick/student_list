defmodule StudentList.Repo.Migrations.CreateClasses do
  use Ecto.Migration

  def change do
    create table(:classes) do
      add :name, :string
      add :teacher, :string
      add :display_order, :integer

      timestamps()
    end
  end
end
