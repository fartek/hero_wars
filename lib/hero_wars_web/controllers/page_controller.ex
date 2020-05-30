defmodule HeroWarsWeb.PageController do
  use HeroWarsWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
