defmodule AdventureWeb.StoryController do
  use AdventureWeb, :controller

  def index(conn, _params) do
    render conn, "index.html", home: home_link(conn)
  end

  def create(conn, %{"story" => %{"text_input" => request}}) when request != "" do
    terms = Adventure.Language.get_terms(request)

    case terms do
      terms ->
        story = %Adventure.Story{}
          |> Adventure.Story.changeset(
            %{
              search_request: request,
              source_text: Adventure.BaseText.compile(terms),
              terms: Adventure.Language.save_terms(terms),
              images: Adventure.Art.compile_art(terms)
            }
          )

        if story.valid? do
          {:ok, record} = Adventure.Repo.insert(story)
          redirect(conn, to: "/begin/#{record.id}")
        else
          render_index(conn, "Couldn't generate a story, for your request.")
        end

      _ -> conn
        message = "Amazing idea, but '#{request}' is harder than it looks."
        render_index(conn, message)
    end
  end

  def create(conn, _params) do
    render_index(conn, "Please enter some text to get started.")
  end

  def show(conn, %{"id" => story_id} = params) do
    story = Adventure.Repo.get(Adventure.Story, story_id)
    page_text = Adventure.Markov.Chain.start(story.source_text)
      |> Adventure.Markov.Chain.page
    image = Adventure.Story.choose_image(story.images)
    render conn, "show.html", home: home_link(conn), story: story, text: page_text, image: image
  end

  def show(conn, _params) do
    render_index(conn)
  end

  defp render_index(conn, message \\ "Something weird happened") do
    conn
    |> put_flash(:error, message)
    |> render("index.html", home: home_link(conn))
  end

  defp home_link(conn), do: "#{conn.scheme}://#{conn.host}:#{conn.port}/begin"
end
