defmodule LunchDetectiveServer.LunchGroupControllerTest do
  use LunchDetectiveServer.ConnCase

  alias LunchDetectiveServer.LunchGroup
  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, lunch_group_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    lunch_group = Repo.insert! %LunchGroup{}
    conn = get conn, lunch_group_path(conn, :show, lunch_group)
    assert json_response(conn, 200)["data"] == %{
      "id" => lunch_group.id
    }
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, lunch_group_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, lunch_group_path(conn, :create), lunch_group: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(LunchGroup, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, lunch_group_path(conn, :create), lunch_group: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    lunch_group = Repo.insert! %LunchGroup{}
    conn = put conn, lunch_group_path(conn, :update, lunch_group), lunch_group: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(LunchGroup, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    lunch_group = Repo.insert! %LunchGroup{}
    conn = put conn, lunch_group_path(conn, :update, lunch_group), lunch_group: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    lunch_group = Repo.insert! %LunchGroup{}
    conn = delete conn, lunch_group_path(conn, :delete, lunch_group)
    assert response(conn, 204)
    refute Repo.get(LunchGroup, lunch_group.id)
  end
end
