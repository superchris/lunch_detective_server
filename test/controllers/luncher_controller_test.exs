defmodule LunchDetectiveServer.LuncherControllerTest do
  use LunchDetectiveServer.ConnCase

  alias LunchDetectiveServer.Luncher
  @valid_attrs %{email: "some content", name: "some content"}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, luncher_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    luncher = Repo.insert! %Luncher{}
    conn = get conn, luncher_path(conn, :show, luncher)
    assert json_response(conn, 200)["data"] == %{
      "id" => luncher.id
    }
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, luncher_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, luncher_path(conn, :create), luncher: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Luncher, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, luncher_path(conn, :create), luncher: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    luncher = Repo.insert! %Luncher{}
    conn = put conn, luncher_path(conn, :update, luncher), luncher: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Luncher, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    luncher = Repo.insert! %Luncher{}
    conn = put conn, luncher_path(conn, :update, luncher), luncher: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    luncher = Repo.insert! %Luncher{}
    conn = delete conn, luncher_path(conn, :delete, luncher)
    assert response(conn, 204)
    refute Repo.get(Luncher, luncher.id)
  end
end
