defmodule LunchDetectiveServer.Lunch do
  use LunchDetectiveServer.Web, :model
  alias LunchDetectiveServer.Repo

  schema "lunches" do
    field :title, :string
    field :url, :string
    field :recommendation, :string
    field :search_term, :string
    field :search_index, :integer
    belongs_to :lunch_group, LunchDetectiveServer.LunchGroup
    has_many :votes, LunchDetectiveServer.Vote
    timestamps
  end

  @required_fields ~w(title)
  @optional_fields ~w(url lunch_group_id recommendation)

  def vote_on(vote) do
    lunch = Repo.get!(LunchDetectiveServer.Lunch, vote.lunch_id) |> Repo.preload([:votes])
    lunch
  end

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
