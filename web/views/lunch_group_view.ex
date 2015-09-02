defmodule LunchDetectiveServer.LunchGroupView do
  use LunchDetectiveServer.Web, :view

  def render("index.json", %{lunch_groups: lunch_groups}) do
    %{lunch_groups: render_many(lunch_groups, LunchDetectiveServer.LunchGroupView, "lunch_group.json")}
  end

  def render("show.json", %{lunch_group: lunch_group}) do
    %{lunch_group: render_one(lunch_group, LunchDetectiveServer.LunchGroupView, "lunch_group.json")}
  end

  def render("lunch_group.json", %{lunch_group: lunch_group}) do
    %{id: lunch_group.id,
      name: lunch_group.name,
      lunchers: Enum.map(lunch_group.lunchers, &(&1.id))
    }
  end
end
