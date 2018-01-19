defmodule Adventure.Markov.Chain do
  alias Adventure.Markov.Model
  alias Adventure.Markov.Gin

  def start(source_text) do
    {:ok, model} = Model.start_link

    Model.populate(model, source_text) # populate markov model with text
  end

  def paragraph(model, length \\ paragraph_length) do
    Enum.map(1..length, fn(_) ->
      model
      |> Gin.create_sentence
    end)
  end

  def page(model) do
    Enum.map(1..paragraph_number(), fn(_) ->
      paragraph(model)
    end)
    |> Enum.join("\n")
    |> remove_glyphs
    |> handle_space
    |> String.split(".")
    |> Enum.map(fn(line) -> line <> "." end)
  end

  defp remove_glyphs(text), do: Regex.replace(~r/\(\d{4}\)|\^|\(|\)/, text, "")
  defp handle_space(text), do: Regex.replace(~r/\;|\W{2+}/, text, " ")
  defp paragraph_length(), do: Enum.random(5..25)
  defp paragraph_number(), do: Enum.random(3..5)
end
