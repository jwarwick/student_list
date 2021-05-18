defmodule StudentList.Repo.Migrations.CreateStudents do
  use Ecto.Migration

  def change do
    create table(:students) do
      add :first_name, :string
      add :last_name, :string
      add :notes, :string
      add :bus_id, references(:buses, on_delete: :nothing)
      add :class_id, references(:classes, on_delete: :nothing)

      timestamps()
    end

    create index(:students, [:bus_id])
    create index(:students, [:class_id])
  end
end
