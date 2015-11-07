defmodule LunchDetectiveServer.Lunch do
  use LunchDetectiveServer.Web, :model
  alias LunchDetectiveServer.Repo
  alias LunchDetectiveServer.Lunch
  alias LunchDetectiveServer.Vote

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
  @optional_fields ~w(url lunch_group_id recommendation search_index search_term)

  def vote_on(vote = %Vote{yes_no: true}, yelp_recommender) do
    Repo.get!(Lunch, vote.lunch_id) |> Repo.preload([:votes])
  end

  def vote_on(vote = %Vote{yes_no: false}, yelp_recommender) do
    lunch = Repo.get!(Lunch, vote.lunch_id) |> Repo.preload([:votes])
    changeset = Lunch.changeset(lunch, recommend_lunch(lunch, yelp_recommender, lunch.search_index + 1))
    Repo.update!(changeset)
  end

  def recommend_lunch(lunch, yelp_recommender), do: recommend_lunch(lunch, yelp_recommender, 0)

  def recommend_lunch(lunch = %Lunch{}, yelp_recommender, index) do
    recommend_lunch(mapify(lunch), yelp_recommender, index)
  end

  def recommend_lunch(lunch_params = %{"search_term" => term}, yelp_recommender, index) do
    recommendation = yelp_recommender.(term, index)
    lunch_params
      |> Map.put("url", recommendation["image_url"])
      |> Map.put("recommendation", recommendation["name"])
      |> Map.put("search_index", index)
  end

  defp mapify(lunch) do
    Enum.reduce(Map.from_struct(lunch), %{}, fn({key, value}, m) -> Map.put(m, Atom.to_string(key), value) end)
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
