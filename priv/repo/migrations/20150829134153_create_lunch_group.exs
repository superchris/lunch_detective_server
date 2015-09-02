defmodule LunchDetectiveServer.Repo.Migrations.CreateLunchGroup do
  use Ecto.Migration

  def change do
    create table(:lunch_groups) do
      add :name, :string

      timestamps
    end

  end
end
