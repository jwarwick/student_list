defmodule StudentList.Repo.Migrations.CreateStudentsAddresses do
  use Ecto.Migration

  def change do
    create table(:students_addresses, primary_key: false) do
      add :student_id, references(:students, on_delete: :nothing), primary_key: true
      add :address_id, references(:addresses, on_delete: :nothing), primary_key: true
    end

    create index(:students_addresses, [:student_id])
    create index(:students_addresses, [:address_id])
  end
end
