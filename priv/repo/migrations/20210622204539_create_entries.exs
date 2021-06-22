defmodule StudentList.Repo.Migrations.CreateEntries do
  use Ecto.Migration

  def change do
    create table(:entries) do
      add :content, :text

      timestamps()
    end
  end
end
