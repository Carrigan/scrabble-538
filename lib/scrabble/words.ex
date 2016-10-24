defmodule Scrabble.Words do
  def load do
    File.stream!("./twl06.txt")
    |> Enum.map(fn line -> String.strip(line) end)
  end

  def of_length(words, n) do
    Enum.filter(words, fn line -> String.length(line) == n end)
  end
end
