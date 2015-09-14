defmodule LunchDetectiveServer.Router do
  use LunchDetectiveServer.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", LunchDetectiveServer do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api", LunchDetectiveServer do
    pipe_through :api
    resources "/lunch_groups", LunchGroupController
    resources "/lunchers", LuncherController
    resources "/lunches", LunchController
  end
end
