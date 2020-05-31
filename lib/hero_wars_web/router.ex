defmodule HeroWarsWeb.Router do
  use HeroWarsWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/", HeroWarsWeb do
    pipe_through :browser

    live "/game", GameLive, layout: {HeroWarsWeb.LayoutView, :app}
  end
end
