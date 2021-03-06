defmodule Adventure.BaseText do
  alias Adventure.Removals
  @moduledoc """
  Gets and parses base text for given keywords.
  """
  @wikipedia_base "https://en.wikipedia.org/wiki/"
  @fanfic_base "https://www.fanfiction.net"

  def compile(tuple_list) do
    # create tasks for all the scrapings
    tasks = Enum.map(tuple_list, fn({term, link}) ->
      [
        Task.async(fn -> Adventure.BaseText.fanfic({term, link}) end),
        Task.async(fn -> Adventure.BaseText.wiki({term, link}) end)
      ]
    end)
    |> List.flatten

    results = Task.yield_many(tasks, 5000)
    |> Enum.map(fn {task, res} ->
      # this removes all borked tasks
      res || Task.shutdown(task, :brutal_kill)
    end)
    # get them results!
    for {:ok, text} <- results do
      text
    end |> Enum.join(" ")
  end

  def wiki(tuple) do
    {keyword, wiki_url} = tuple
    {:ok, response} = cond do
      wiki_url -> HTTPoison.get(wiki_url)
      true ->
        searchable_keyword = keyword
          |> capitalize_parts
          |> prep_term("_")
        HTTPoison.get(@wikipedia_base <> searchable_keyword)
    end

    case response.status_code do
      200 ->
        Floki.find(response.body, ".mw-parser-output")
        #add p.:nth-child(1-10)?
        # getting far too much wiki text.

          |> Floki.text
          |> Removals.check
      _  -> []
    end
  end

  def fanfic(tuple) do
    {keyword, _} = tuple
    term = keyword
      |> prep_term("%20")
    search = "/search/?ready=1&keywords=#{term}&categoryid=0&genreid1=0&genreid2=0&languageid=1&censorid=0&statusid=2&type=story&match=&sort=&ppage=1&characterid1=0&characterid2=0&characterid3=0&characterid4=0&words=4&formatid=0"

    {:ok, response} = HTTPoison.get(@fanfic_base <> search)

    story_url = Floki.find(response.body, ".stitle")
      |> Floki.attribute("href")
      |> List.first
    cond do
      story_url ->
        {:ok, story_response} = HTTPoison.get(@fanfic_base <> story_url)

        story_response.body
          |> Floki.find(".storytext")
          |> Floki.text
          |> Removals.check
      true -> []
    end
  end

  defp capitalize_parts(string) do
    String.split(string, " ")
      |> Enum.map(&String.capitalize(&1))
      |> Enum.join(" ")
  end

  defp prep_term(keyword, spacer), do: Regex.replace(~r{\s}, keyword, spacer)
end
