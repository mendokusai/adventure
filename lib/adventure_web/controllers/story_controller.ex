defmodule AdventureWeb.StoryController do
  use AdventureWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def show(conn, %{"story" => %{"text_input" => request}}) do
    terms = Adventure.Language.get_terms(request)
    base_text = Adventure.BaseText.compile(terms)

    %Adventure.Story{}
      |> Adventure.Story.changeset(%{search_request: request,source_text: base_text})
      |> Adventure.Repo.insert!

    render conn, "show.html", show_terms: terms
  end
end
