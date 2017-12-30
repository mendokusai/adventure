defmodule Adventure.Story do
  use Ecto.Schema
  import Ecto.Changeset

  @moduledoc """
  The goal of this is to encapuslate information for a story,
  so key terms, markov chain details.
  Adventure.Story %{
    search_request: "I like ponies",
    terms: [{"<keyword>", <TYPE>}...],
    sites_visited: []
  }

  TYPES: [
    UNKNOWN, PERSON, LOCATION, ORGANIZATION,
    EVENT, WORK_OF_ART, CONSUMER_GOOD, OTHER
  ]
  """
  embedded_schema do
    field :search_request, :string
    embeds_many :terms, Adventure.Terms
  end

  @allowed_attributes [:search_request]

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @allowed_attributes)
    |> cast_embed(:terms)
  end
end
