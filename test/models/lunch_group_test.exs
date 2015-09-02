defmodule LunchDetectiveServer.LunchGroupTest do
  use LunchDetectiveServer.ModelCase

  alias LunchDetectiveServer.LunchGroup

  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = LunchGroup.changeset(%LunchGroup{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = LunchGroup.changeset(%LunchGroup{}, @invalid_attrs)
    refute changeset.valid?
  end
end
