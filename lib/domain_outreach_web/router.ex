defmodule DomainOutreachWeb.Router do
  use DomainOutreachWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/", DomainOutreachWeb do
    pipe_through :browser
    get "/", PageController, :home
    get "/test-oban", PageController, :test_oban
  end
end