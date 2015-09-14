defmodule LunchDetectiveServer.LunchView do
  use LunchDetectiveServer.Web, :view

  def render("index.json", %{lunches: lunches}) do
    %{lunches: render_many(lunches, LunchDetectiveServer.LunchView, "lunch.json")}
  end

  def render("show.json", %{lunch: lunch}) do
    %{lunch: render_one(lunch, LunchDetectiveServer.LunchView, "lunch.json")}
  end

  def render("lunch.json", %{lunch: lunch}) do
    %{id: lunch.id,
      title: lunch.title,
      url: lunch.url,
      lunch_group_id: lunch.lunch_group_id}
  end
end
