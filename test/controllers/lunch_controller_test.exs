defmodule LunchDetectiveServer.LunchControllerTest do
  use LunchDetectiveServer.ConnCase

  alias LunchDetectiveServer.Lunch
  @valid_attrs %{title: "some content", url: "some content"}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, lunch_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    lunch = Repo.insert! %Lunch{}
    conn = get conn, lunch_path(conn, :show, lunch)
    assert json_response(conn, 200)["data"] == %{
      "id" => lunch.id
    }
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, lunch_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, lunch_path(conn, :create), lunch: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Lunch, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, lunch_path(conn, :create), lunch: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    lunch = Repo.insert! %Lunch{}
    conn = put conn, lunch_path(conn, :update, lunch), lunch: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Lunch, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    lunch = Repo.insert! %Lunch{}
    conn = put conn, lunch_path(conn, :update, lunch), lunch: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    lunch = Repo.insert! %Lunch{}
    conn = delete conn, lunch_path(conn, :delete, lunch)
    assert response(conn, 204)
    refute Repo.get(Lunch, lunch.id)
  end
end
