defmodule Adventure.Art do
  @moduledoc """
  This is to encapsulate all effort to get images with artsy.
  returns a list of large images from Artsy.
  """

  @api_secret System.get_env("CHOOSE_ART_SECRET")
  @api_client System.get_env("CHOOSE_ART_CLIENT_ID")
  @artsy_url "https://api.artsy.net/api/"
  @token_url "#{@artsy_url}tokens/xapp_token?client_id=#{@api_client}&client_secret=#{@api_secret}"

  def compile_art(tuple_list) do
    token = get_token()
    tasks = Enum.map(tuple_list, fn {term, _link} ->
      Task.async(fn -> acquire_art(term, token) end)
    end)

    results = Task.yield_many(tasks, 5000)
      |> Enum.map(fn {task, res} ->
      # this removes all borked tasks
      res || Task.shutdown(task, :brutal_kill)
    end)

    for {:ok, lists} <- results do
      lists
    end |> List.flatten
  end

  def acquire_art(term, token) do
    image_search(term, token)
      |> viable_thumbnails
      |> Enum.filter(&is_bitstring(&1))
      |> correct_url_length
      |> enlarge_image()
  end

  def get_token() do
    response = HTTPoison.post!(@token_url, "")
    JSON.decode!(response.body)["token"]
  end

  defp image_search(term, token \\ get_token()) do
    search_url = "#{@artsy_url}search?q=#{prepared_term(term)}"
    headers = %{"X-XAPP-Token" => token}
    response = HTTPoison.get!(search_url, headers)
    json = JSON.decode!(response.body)
    {json["_embedded"]["results"], json["total_count"]}
  end

  defp viable_thumbnails({_results, count}) when count == 0, do: []
  defp viable_thumbnails({results, _count}) do
    Enum.map(results, fn(work) ->
        work["_links"]["thumbnail"]["href"]
    end)
  end

  defp correct_url_length(list) do
    Enum.filter(list, fn url ->
      String.length(url) < 80 && String.length(url) > 60
    end)
  end

  defp enlarge_image([]), do: ["https://www.fillmurray.com/400/300"]
  defp enlarge_image(list), do: Enum.map(list, &(Regex.replace(~r{square}, &1, "large")))

  defp prepared_term(term), do: Regex.replace(~r{\s}, term, "+")
end
