defmodule LunchDetectiveServer.LunchController do
  require IEx
  use LunchDetectiveServer.Web, :controller

  alias LunchDetectiveServer.Lunch
  alias LunchDetectiveServer.Yelp

  plug :scrub_params, "lunch" when action in [:create, :update]

  def index(conn, _params) do
    lunches = Repo.all(Lunch)
    render(conn, "index.json", lunches: lunches)
  end

  def create(conn, %{"lunch" => lunch_params}) do
    changeset = Lunch.changeset(%Lunch{}, Map.put(lunch_params, "url", yelp_recommendation))

    case Repo.insert(changeset) do
      {:ok, lunch} ->
        conn
        |> put_status(:created)
        |> render("show.json", lunch: lunch)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(LunchDetectiveServer.ChangesetView, "error.json", changeset: changeset)
    end
  end

  defp yelp_recommendation do
    List.first(Yelp.search.businesses)["image_url"]
  end

  def show(conn, %{"id" => id}) do
    lunch = Repo.get!(Lunch, id)
    render conn, "show.json", lunch: lunch
  end

  def update(conn, %{"id" => id, "lunch" => lunch_params}) do
    lunch = Repo.get!(Lunch, id)
    changeset = Lunch.changeset(lunch, lunch_params)

    case Repo.update(changeset) do
      {:ok, lunch} ->
        render(conn, "show.json", lunch: lunch)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(LunchDetectiveServer.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    lunch = Repo.get!(Lunch, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    lunch = Repo.delete!(lunch)

    send_resp(conn, :no_content, "")
  end
end
