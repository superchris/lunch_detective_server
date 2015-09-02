defmodule LunchDetectiveServer.LuncherController do
  use LunchDetectiveServer.Web, :controller

  alias LunchDetectiveServer.Luncher

  plug :scrub_params, "luncher" when action in [:create, :update]

  def index(conn, _params) do
    lunchers = Repo.all(Luncher)
    render(conn, "index.json", lunchers: lunchers)
  end

  def create(conn, %{"luncher" => luncher_params}) do
    changeset = Luncher.changeset(%Luncher{}, luncher_params)

    case Repo.insert(changeset) do
      {:ok, luncher} ->
        conn
        |> put_status(:created)
        |> render("show.json", luncher: luncher)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(LunchDetectiveServer.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    luncher = Repo.get!(Luncher, id)
    render conn, "show.json", luncher: luncher
  end

  def update(conn, %{"id" => id, "luncher" => luncher_params}) do
    luncher = Repo.get!(Luncher, id)
    changeset = Luncher.changeset(luncher, luncher_params)

    case Repo.update(changeset) do
      {:ok, luncher} ->
        render(conn, "show.json", luncher: luncher)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(LunchDetectiveServer.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    luncher = Repo.get!(Luncher, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    luncher = Repo.delete!(luncher)

    send_resp(conn, :no_content, "")
  end
end
