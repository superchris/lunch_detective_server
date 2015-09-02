defmodule LunchDetectiveServer.LunchesController do
  use LunchDetectiveServer.Web, :controller

  alias LunchDetectiveServer.Lunches

  plug :scrub_params, "lunches" when action in [:create, :update]

  def index(conn, _params) do
    lunches = Repo.all(Lunches)
    render(conn, "index.json", lunches: lunches)
  end

  def create(conn, %{"lunches" => lunches_params}) do
    changeset = Lunches.changeset(%Lunches{}, lunches_params)

    case Repo.insert(changeset) do
      {:ok, lunches} ->
        conn
        |> put_status(:created)
        |> render("show.json", lunches: lunches)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(LunchDetectiveServer.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    lunches = Repo.get!(Lunches, id)
    render conn, "show.json", lunches: lunches
  end

  def update(conn, %{"id" => id, "lunches" => lunches_params}) do
    lunches = Repo.get!(Lunches, id)
    changeset = Lunches.changeset(lunches, lunches_params)

    case Repo.update(changeset) do
      {:ok, lunches} ->
        render(conn, "show.json", lunches: lunches)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(LunchDetectiveServer.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    lunches = Repo.get!(Lunches, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    lunches = Repo.delete!(lunches)

    send_resp(conn, :no_content, "")
  end
end
