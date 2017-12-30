defmodule Adventure.Language do
  @moduledoc """
  Parses input string into json and builds request for Google Language API
  https://cloud.google.com/natural-language/docs/reference/rest/v1/documents

  Set up as two parts to test `build_json` and then `make_request` separately.
  I'm unsure if `decode_response` is necessary here
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
