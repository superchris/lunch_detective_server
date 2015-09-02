defmodule LunchDetectiveServer.LuncherTest do
  use LunchDetectiveServer.ModelCase

  alias LunchDetectiveServer.Luncher

  @valid_attrs %{email: "some content", name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Luncher.changeset(%Luncher{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Luncher.changeset(%Luncher{}, @invalid_attrs)
    refute changeset.valid?
  end
end
