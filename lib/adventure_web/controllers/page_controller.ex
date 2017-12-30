defmodule AdventureWeb.PageController do
  use AdventureWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
