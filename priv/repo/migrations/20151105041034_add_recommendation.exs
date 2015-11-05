defmodule LunchDetectiveServer.Repo.Migrations.AddRecommendation do
  use Ecto.Migration

  def change do
    alter table(:lunches) do
      add :recommendation, :string
    end
  end

end
