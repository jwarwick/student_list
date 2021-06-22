defmodule StudentList.Repo.Migrations.UpdateStudentsAddressesEntries do
  use Ecto.Migration

  def change do
    alter table(:students) do
      add :entry_id, references(:entries, on_delete: :delete_all)
    end

    alter table(:addresses) do
      add :entry_id, references(:entries, on_delete: :delete_all)
    end
  end
end
