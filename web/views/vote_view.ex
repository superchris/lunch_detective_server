defmodule LunchDetectiveServer.VoteView do
  use LunchDetectiveServer.Web, :view

  def render("index.json", %{votes: votes}) do
    %{votes: render_many(votes, LunchDetectiveServer.VoteView, "vote.json")}
  end

  def render("show.json", %{vote: vote}) do
    %{vote: render_one(vote, LunchDetectiveServer.VoteView, "vote.json")}
  end

  def render("vote.json", %{vote: vote}) do
    %{id: vote.id,
      name: vote.name,
      email: vote.email,
      yes_no: vote.yes_no,
      lunch_id: vote.lunch_id}
  end
end
