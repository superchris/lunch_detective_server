defmodule LunchDetectiveServer.Repo.Migrations.CreateLuncher do
  use Ecto.Migration

  def change do
    create table(:lunchers) do
      add :name, :string
      add :email, :string
      add :lunch_group_id, references(:lunch_groups)

      timestamps
    end
    create index(:lunchers, [:lunch_group_id])

  end
end
