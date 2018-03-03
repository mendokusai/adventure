defmodule Adventure.Markov.Chain do
  alias Adventure.Markov.Model
  alias Adventure.Markov.Gin

  def start(source_text) do
    {:ok, model} = Model.start_link

    Model.populate(model, source_text) # populate markov model with text
  end

  def paragraph(model, length \\ paragraph_length()) do
    Enum.map(1..length, fn(_) ->
      model
      |> Gin.create_sentence
    end)
      |> Enum.map(fn(x) -> x <> "." end)
      |> Adventure.Removals.check
      |> Adventure.Personify.you
  end

  def page(model) do
    Enum.map(1..paragraph_number(), fn(_) ->
      paragraph(model)
    end)
  end

  defp paragraph_length(), do: Enum.random(2..3)
  defp paragraph_number(), do: Enum.random(2..4)
end
