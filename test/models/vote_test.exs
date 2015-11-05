defmodule LunchDetectiveServer.VoteTest do
  use LunchDetectiveServer.ModelCase

  alias LunchDetectiveServer.Vote

  @valid_attrs %{yes_no: true, email: "fred@example.com", name: "Fred"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Vote.changeset(%Vote{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Vote.changeset(%Vote{}, @invalid_attrs)
    refute changeset.valid?
  end
end
