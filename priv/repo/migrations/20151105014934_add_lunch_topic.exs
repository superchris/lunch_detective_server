defmodule LunchDetectiveServer.Repo.Migrations.AddLunchTopic do
  use Ecto.Migration

  def change do
    alter table(:lunches) do
      add :search_term, :string
      add :search_index, :integer
    end
  end
end
