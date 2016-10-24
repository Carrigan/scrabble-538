defmodule Scrabble.CLI do
  alias Scrabble.{Words, Tree, Parallel}
  def main(_args) do
    words = Words.load

    roots(words)
    |> branch_until(words, longest_word(words))
    |> Parallel.pmap(fn nd -> Tree.find_longest_chain(nd) end)
    |> Enum.map(fn nd -> IO.inspect nd end)
  end

  def longest_word(words) do
    Enum.reduce(words, 0, fn word, acc -> Enum.max [String.length(word), acc] end)
  end

  def branch_until(nodes, words, longest) do
    branch_until(nodes, words, longest, 3)
  end

  def branch_until(nodes, _, longest, current) when current > longest, do: nodes

  def branch_until(nodes, words, longest, current) do
    IO.puts current
    branch_until(branch(nodes, words, current), words, longest, current + 1)
  end

  def roots(words) do
    words
    |> Words.of_length(2)
    |> Tree.build_root
  end

  def branch(nodes, words, n) do
    Parallel.pmap(
      nodes,
      fn node -> Tree.build_tier(node, Words.of_length(words, n), n - 1) end
    )
  end
end
