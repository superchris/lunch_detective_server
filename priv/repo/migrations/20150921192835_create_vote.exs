defmodule LunchDetectiveServer.Repo.Migrations.CreateVote do
  use Ecto.Migration

  def change do
    create table(:votes) do
      add :yes_no, :boolean, default: false
      add :lunch_id, references(:lunches)
      add :name, :string
      add :email, :string

      timestamps
    end
    create index(:votes, [:lunch_id])

  end
end
