defmodule Adventure.Markov do
  @moduledoc """
  Builds sentences and paragraphs from source text.
  """

  def sentence(chain, length \\ sentence_length) do
    Faust.traverse(chain, length)
  end

  defp para_length(), do: Enum.random(4..8)
  defp sentence_length(), do: Enum.random(4..12)
end
