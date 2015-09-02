defmodule LunchDetectiveServer.LunchesControllerTest do
  use LunchDetectiveServer.ConnCase

  alias LunchDetectiveServer.Lunches
  @valid_attrs %{title: "some content", url: "some content"}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, lunches_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    lunches = Repo.insert! %Lunches{}
    conn = get conn, lunches_path(conn, :show, lunches)
    assert json_response(conn, 200)["data"] == %{
      "id" => lunches.id
    }
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, lunches_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, lunches_path(conn, :create), lunches: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Lunches, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, lunches_path(conn, :create), lunches: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    lunches = Repo.insert! %Lunches{}
    conn = put conn, lunches_path(conn, :update, lunches), lunches: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Lunches, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    lunches = Repo.insert! %Lunches{}
    conn = put conn, lunches_path(conn, :update, lunches), lunches: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    lunches = Repo.insert! %Lunches{}
    conn = delete conn, lunches_path(conn, :delete, lunches)
    assert response(conn, 204)
    refute Repo.get(Lunches, lunches.id)
  end
end
