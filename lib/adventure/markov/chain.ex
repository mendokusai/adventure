defmodule Adventure.Markov.Chain do
  alias Adventure.Markov.Model
  alias Adventure.Markov.Gin

  def start(source) do
    process_source(source)
    # System.halt(0) # interesting. kills the whole thing.
  end

  defp process_source(text) do
    {:ok, model} = Model.start_link
    model = Model.populate(model, text) # populate markov model with text
    # generate 10 random lines from text source
    Enum.each(1..10, fn(_) ->
      model |> Gin.create_sentence |> IO.puts
    end)
  end
end
