defmodule LunchDetectiveServer.LunchTest do
  use LunchDetectiveServer.ModelCase

  alias LunchDetectiveServer.Lunch
  alias LunchDetectiveServer.Vote

  @valid_attrs %{title: "some content", url: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Lunch.changeset(%Lunch{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Lunch.changeset(%Lunch{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "vote_on" do
    lunch = Lunch.changeset(%Lunch{}, %{title: "Hey", search_index: 0, search_term: "wut"}) |> Repo.insert!
    vote = Vote.changeset(%Vote{}, %{yes_no: false, lunch_id: lunch.id, email: "foo@bar.com", name: "Fred"})
      |> Repo.insert!
    lunch = Lunch.vote_on(vote, &fake_yelp/2)
    assert lunch.search_index == 1
    assert lunch.recommendation == "wut"
    assert lunch.url == "two"
  end

  def fake_yelp(term, index) do
    recs = [%{"image_url" => "one", "name" => term}, %{"image_url" => "two", "name" => term}]
    Enum.at recs, index
  end

  test "recommend lunch" do
    lunch = Lunch.changeset(%Lunch{}, %{title: "Hey", search_term: "Food"}) |> Repo.insert!
    recommended = Lunch.recommend_lunch(lunch, &fake_yelp/2, 1)
    assert recommended["url"] == "two"
    assert recommended["recommendation"] == "Food"
    assert recommended["search_index"] == 1
  end

  test "recommend lunch with no index" do
    lunch = Lunch.changeset(%Lunch{}, %{title: "Hey", search_term: "Food"}) |> Repo.insert!
    recommended = Lunch.recommend_lunch(lunch, &fake_yelp/2)
    assert recommended["url"] == "one"
    assert recommended["recommendation"] == "Food"
    assert recommended["search_index"] == 0
  end

end
