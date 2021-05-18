defmodule StudentList.Repo.Migrations.CreateAddresses do
  use Ecto.Migration

  def change do
    create table(:addresses) do
      add :address1, :string
      add :address2, :string
      add :city, :string
      add :state, :string
      add :zip, :string
      add :phone, :string

      timestamps()
    end
  end
end
