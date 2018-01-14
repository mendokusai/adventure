defmodule AdventureWeb.StoryController do
  use AdventureWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def create(conn, %{"story" => %{"text_input" => request}}) do
    terms = Adventure.Language.get_terms(request)

    story = %Adventure.Story{}
      |> Adventure.Story.changeset(
        %{
          search_request: request,
          source_text: Adventure.BaseText.compile(terms),
          terms: Adventure.Language.save_terms(terms)
        }
      )
      |> Adventure.Repo.insert!

    redirect conn, to: "/begin/#{story.id}"
  end

  def show(conn, %{"id" => story_id} = params) do
    story = Adventure.Repo.get(Adventure.Story, story_id)
    # temporary patch, fix base-text
    #
    text = Regex.replace(~r/[\(\d{4}\)|\^]/, story.source_text, "")
    page_text = Adventure.Markov.Chain.start(text)
    |> Adventure.Markov.Chain.page
    render conn, "show.html", story: story, text: page_text
  end
end
