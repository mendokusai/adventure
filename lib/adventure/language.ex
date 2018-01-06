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
    {:ok, json} = build_json(string)
    {:ok, response} = make_request(json)
    decode_response(response.body)
  end

  def build_json(string) do
    string
    |> body_args
    |> JSON.encode
  end

  def make_request(body_json), do: HTTPoison.post(@url, body_json, @headers)

  def decode_response(body) do
    body
    |> JSON.decode
    |> terms_list
  end

  def save_terms(tuple_list) do
    Enum.map(tuple_list, fn({keyword, _}) -> keyword end)
  end

  defp terms_list(tuple) do
    {:ok, map} = tuple
    Enum.map(map["entities"], fn(entry) ->
      {entry["name"], entry["metadata"]["wikipedia_url"]}
    end)
  end

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
