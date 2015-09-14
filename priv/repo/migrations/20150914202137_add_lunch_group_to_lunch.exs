defmodule LunchDetectiveServer.Repo.Migrations.AddLunchGroupToLunch do
  use Ecto.Migration

  def change do
    alter table(:lunches) do
      add :lunch_group_id, references(:lunch_groups)
    end
    create index(:lunches, [:lunch_group_id])
  end
end
