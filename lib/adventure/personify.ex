defmodule Adventure.Personify do
  @moduledoc """
  Change randomly generated text intances to "you" & "your"
  """

  def you(text_list), do: Enum.map(text_list, &swap_person(&1))

  def swap_person(line) do
    # wanted to make sure not to grab _every_ instance.
    if a_guy?(line) do
      line
      |> match_he_d
      |> match_he_is
      |> match_he
      |> match_his
      |> match_himself
      |> match_him
      |> remove_male
    else
      line
      |> match_she_d
      |> match_she_is
      |> match_she
      |> match_herself
      |> match_her
      |> remove_female
    end
  end

  defp a_guy?(line), do: Regex.match?(~r/he|him|his/, line)

  defp match_he(line), do: Regex.replace(~r/(?<=\s)he(?=\s)|(!<a-z)he(?=\s)/, line, "you")
  defp match_him(line), do: Regex.replace(~r/him/, line, "you")
  defp match_he_is(line), do: Regex.replace(~r/he\sis/, line, "you are")
  defp match_his(line), do: Regex.replace(~r/(?<=\s)his(?=\s)|(!<a-z)his(?=\s)/, line, "your")
  defp match_he_d(line), do: Regex.replace(~r/he'd/, line, "you'd")
  defp match_himself(line), do: Regex.replace(~r/himself/, line, "you")
  defp remove_male(line), do: Regex.replace(~r/male?\s/, line, "")

  defp match_her(line), do: Regex.replace(~r/her/, line, "your")
  defp match_she_is(line), do: Regex.replace(~r/she\wis/, line, "you are")
  defp match_she(line), do: Regex.replace(~r/she/, line, "you")
  defp match_she_d(line), do: Regex.replace(~r/she'd/, line, "you'd")
  defp match_herself(line), do: Regex.replace(~r/herself/, line, "yourself")
  defp remove_female(line), do: Regex.replace(~r/female?\s/, line, "")
end
