defmodule LunchDetectiveServer.LuncherView do
  use LunchDetectiveServer.Web, :view

  def render("index.json", %{lunchers: lunchers}) do
    %{lunchers: render_many(lunchers, LunchDetectiveServer.LuncherView, "luncher.json")}
  end

  def render("show.json", %{luncher: luncher}) do
    %{luncher: render_one(luncher, LunchDetectiveServer.LuncherView, "luncher.json")}
  end

  def render("luncher.json", %{luncher: luncher}) do
    %{id: luncher.id,
      name: luncher.name,
      email: luncher.email,
      lunch_group_id: luncher.lunch_group_id}
  end
end
