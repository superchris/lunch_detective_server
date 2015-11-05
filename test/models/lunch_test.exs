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
    lunch = Lunch.changeset(%Lunch{}, %{title: "Hey"}) |> Repo.insert!
    vote = Vote.changeset(%Vote{}, %{yes_no: true, lunch_id: lunch.id, email: "foo@bar.com", name: "Fred"})
      |> Repo.insert!
    IO.inspect(lunch)
    IO.inspect(Lunch.vote_on(vote))
    assert true
  end

end
