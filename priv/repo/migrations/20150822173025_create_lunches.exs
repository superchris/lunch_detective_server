defmodule LunchDetectiveServer.Repo.Migrations.CreateLunches do
  use Ecto.Migration

  def change do
    create table(:lunches) do
      add :title, :string
      add :url, :string

      timestamps
    end

  end
end
