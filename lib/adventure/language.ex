defmodule Adventure.Language do
  @moduledoc """
  Parses input string into json and builds request for Google Language API
  https://cloud.google.com/natural-language/docs/reference/rest/v1/documents

  Goal is to process a user string through the google API to break it down into parts.
  special types (below) will come with a wikipedia link,
  which we pass in to a tuple response if possible.

  The function `get_terms` prepares a tuple list to be fed into `Adventure.BaseText.compile`.
  `build_json` and `make_request` were set up separately for testing.

  Types from Google:
  TYPES: [
    UNKNOWN, PERSON, LOCATION, ORGANIZATION,
    EVENT, WORK_OF_ART, CONSUMER_GOOD, OTHER
  ]
  """
  @api_key System.get_env("GOOGLE_LANGUAGE_API")
  @headers [{"Content-Type", "application/json"}, {"Accept", "application/json"}]
  @url "https://language.googleapis.com/v1/documents:analyzeEntities?key=#{@api_key}"

  def get_terms(string) do
    response = build_json(string)
      |> make_request
    decode_response(response, string)
  end

  def build_json(string) do
    string
    |> body_args
    |> JSON.encode!
  end

  def make_request(body_json), do: HTTPoison.post(@url, body_json, @headers)

  def decode_response({:ok, response}, string) do
    response.body
    |> JSON.decode!
    |> terms_list
    |> result_or_original(string)
  end

  def decode_response({code, _response}, string) when code != :ok ,do: [{string, nil}]

  def save_terms(tuple_list) do
    Enum.map(tuple_list, fn({keyword, _}) -> keyword end)
  end

  defp terms_list(response_map) do
    Enum.map(response_map["entities"], fn(entry) ->
      {entry["name"], entry["metadata"]["wikipedia_url"]}
    end)
  end

  defp result_or_original([], original_string), do: [{original_string, nil}]
  defp result_or_original(result_map, _original_string), do: result_map

  defp body_args(string) do
    [
      document: [
        content: string,
        type: "PLAIN_TEXT"
      ],
      encodingType: "UTF8"
    ]
  end
end
