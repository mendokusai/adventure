defmodule Adventure.Markov.Gin do
  alias Adventure.Markov.Model
  @threshold 0.5 # value from https://github.com/ne1ro/elixir-markov-chain/blob/master/config/config.exs#L13

  def create_sentence(pid) do
    {sentence, prob} = build_sentence(pid)

    # create new sentence or convert built based on threshold val
    if prob >= @threshold do
      sentence |> Enum.join(" ") |> String.capitalize
    else
      create_sentence(pid)
    end
  end

  defp complete?(tokens) do
    length(tokens) > 15 ||
    (length(tokens) > 3 && Regex.match?(~r{[\!\?\.]\z}, List.last tokens))
  end

  defp build_sentence(pid), do: build_sentence(pid, [], 0.0, 0.0)
  defp build_sentence(pid, tokens, prob_acc, new_tokens) do
    # fetch markov model state through agent
    {token, prob} = tokens
      |> Model.fetch_state
      |> Model.fetch_token(pid)
    case complete?(tokens) do
      true ->
        score = case new_tokens == 0 do
          true -> 1.0
          _ -> prob_acc / new_tokens # count new probability for this word
        end
        {tokens, score}
      _ ->
      # concat sentence with new token and try to continue
      build_sentence(pid, tokens ++ [token], prob + prob_acc, new_tokens + 1)
    end
  end
end
