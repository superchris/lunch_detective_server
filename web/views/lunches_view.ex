defmodule LunchDetectiveServer.LunchesView do
  use LunchDetectiveServer.Web, :view

  def render("index.json", %{lunches: lunches}) do
    %{data: render_many(lunches, LunchDetectiveServer.LunchesView, "lunches.json")}
  end

  def render("show.json", %{lunches: lunches}) do
    %{data: render_one(lunches, LunchDetectiveServer.LunchesView, "lunches.json")}
  end

  def render("lunches.json", %{lunches: lunches}) do
    %{id: lunches.id,
      title: lunches.title,
      url: lunches.url}
  end
end
