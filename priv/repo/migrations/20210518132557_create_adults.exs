defmodule StudentList.Repo.Migrations.CreateAdults do
  use Ecto.Migration

  def change do
    create table(:adults) do
      add :first_name, :string
      add :last_name, :string
      add :email, :string
      add :mobile_phone, :string
      add :address_id, references(:addresses, on_delete: :nothing)

      timestamps()
    end

    create index(:adults, [:address_id])
  end
end
