defmodule Adventure.Removals do
  def check(terms) when is_list(terms), do: Enum.map(terms, &check(&1))

  def check(text) do
    text
      |> remove_footnotes
      |> cap_imma
      |> dot_space
      |> nix_glyphs
      |> remove_long_strings
      |> cul_space
      |> ending
      |> String.trim
  end

  defp remove_long_strings(text) do
    text
      |> String.split(" ")
      |> Enum.map(&fix_word(&1))
      |> Enum.join(" ")
  end

  defp remove_footnotes(text), do: Regex.replace(~r/\d{4}|(\[\d+\])/, text, " ")
  defp nix_glyphs(text), do: Regex.replace(~r/\(\d{4}\)|\d{4}\-\d{4}|\[|\]|\;|\^|\(|\)|,$/, text, "  ")
  defp cul_space(text), do: Regex.replace(~r/\s{2,10}/, text, " ")
  defp cap_imma(text), do: Regex.replace(~r/i(?=\')|(?<=\s)i(?=\s)/, text, "I")
  defp dot_space(text), do: Regex.replace(~r/(?<!\s)\.(?!\s)|(?<!\s)\,(?!\s)/, text, ". ")
  defp ending(text), do: Regex.replace(~r/(\.\s)+/, text, ". ")

  defp fix_word(word) do
    if String.length(word) > 10 do
      ""
    else
      word
    end
  end
end
