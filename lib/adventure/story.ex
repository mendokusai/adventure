defmodule Adventure.Story do
  use Ecto.Schema
  import Ecto.Changeset

  @moduledoc """
  The goal of this is to encapuslate information for a story,
  so key terms, markov chain details.
  Adventure.Story %{
    search_request: "I like ponies",    # Original request string
    source_text: "<big lot of text">,   # Result from Adventure.BaseText.compile
    terms: [{"<keyword>", <TYPE>}...]   # Result from Adventure.Language.get_terms
  }
  """
  schema "story" do
    field :search_request, :string
    field :source_text, :string # text for making markov chains
    field :terms, {:array, :string} # this is a list, processed from search_request

    timestamps()
  end

  @required_fields [:search_request, :source_text, :terms]

  def changeset(%Adventure.Story{} = story, params) do
    story
    |> cast(params, @required_fields)
    |> validate_required([:search_request, :source_text, :terms])
  end
end
