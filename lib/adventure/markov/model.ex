defmodule Adventure.Markov.Model do

  # create map for sharing through agent
  def start_link, do: Agent.start_link(fn -> %{} end)

  def populate(pid, text) do
    # populate model with tokens
    for tokens <- tokenize(text), do: modelize(pid, tokens)
    pid
  end

  def fetch_token(state, pid) do
    tokens = fetch_tokens(state, pid)

    if length(tokens) > 0 do
      token = Enum.random(tokens)
      count = tokens |> Enum.count(&(token == &1))
      {token, count / length(tokens)} # count probability of token
    else
      {"", 0.0}
    end
  end

  def fetch_state(tokens), do: fetch_state(tokens, length(tokens))

  defp fetch_state(_tokens, id) when id == 0, do: {nil, nil}
  defp fetch_state([head | _tail], id) when id == 1, do: {nil, head}
  defp fetch_state(tokens, id) do
    tokens
    |> Enum.slice(id - 2..id - 1) # fetch states by id
    |> List.to_tuple
  end

  # get tokens within agent
  defp fetch_tokens(state, pid), do: Agent.get pid, &(&1[state]|| [])

  # buld markov chain model using tokens
  defp modelize(pid, tokens) do
    for{token, id} <- Enum.with_index(tokens) do
      tokens
        |> fetch_state(id)
        |> add_state(pid, token)
    end
  end

  # add new state within agent
  defp add_state(state, pid, token) do
    Agent.update(pid, fn(model) ->
      current_state = model[state] || []
      Map.put(model, state, [token | current_state])
    end)
  end

  defp tokenize(text) do
    text
    |> String.downcase
    |> String.split(~r{\n}, trim: true)
    |> Enum.map(&String.split/1)
  end
end
