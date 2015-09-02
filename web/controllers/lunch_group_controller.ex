defmodule LunchDetectiveServer.LunchGroupController do
  use LunchDetectiveServer.Web, :controller

  alias LunchDetectiveServer.LunchGroup

  plug :scrub_params, "lunch_group" when action in [:create, :update]

  def index(conn, _params) do
    lunch_groups = Repo.all(LunchGroup) |> Repo.preload [:lunchers]
    render(conn, "index.json", lunch_groups: lunch_groups)
  end

  def create(conn, %{"lunch_group" => lunch_group_params}) do
    changeset = LunchGroup.changeset(%LunchGroup{}, lunch_group_params)

    case Repo.insert(changeset) do
      {:ok, lunch_group} ->
        conn
        |> put_status(:created)
        |> render("show.json", lunch_group: Repo.preload(lunch_group, [:lunchers]))
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(LunchDetectiveServer.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    lunch_group = Repo.get!(LunchGroup, id) |> Repo.preload [:lunchers]
    render conn, "show.json", lunch_group: lunch_group
  end

  def update(conn, %{"id" => id, "lunch_group" => lunch_group_params}) do
    lunch_group = Repo.get!(LunchGroup, id)
    changeset = LunchGroup.changeset(lunch_group, lunch_group_params)

    case Repo.update(changeset) do
      {:ok, lunch_group} ->
        render(conn, "show.json", lunch_group: lunch_group)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(LunchDetectiveServer.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    lunch_group = Repo.get!(LunchGroup, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    lunch_group = Repo.delete!(lunch_group)

    send_resp(conn, :no_content, "")
  end
end
