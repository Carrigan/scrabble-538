defmodule Scrabble.Tree do
  alias Scrabble.Node

  def build_root(words) do
    Enum.map(words, fn word -> build_node(word) end)
  end

  def build_node(word) do
    %Node{
      value: word,
      length: String.length(word),
      children: []
    }
  end

  def build_tier(node, words, length) do
    if length == node.length do
      %{node | children: build_new_children(node.value, words)}
    else
      %{node | children: Enum.map(node.children, fn child -> build_tier(child, words, length) end)}
    end
  end

  def build_new_children(root, words) do
    Enum.reduce(
      words,
      [],
      fn (word, acc) ->
        if String.contains? word, root do
          acc ++ [build_node(word)]
        else
          acc
        end
      end
    )
  end

  def find_longest_chain(node) do
    find_longest_chain(node, [], {0, []})
  end

  def find_longest_chain(current = %Node{children: []}, path, best = {b_length, b_list}) do
    cond do
      current.length > b_length -> {current.length, [path ++ [current.value]]}
      current.length == b_length -> {current.length, b_list ++ [path ++ [current.value]]}
      true -> best
    end
  end

  def find_longest_chain(parent, path, best) do
    Enum.reduce(
      parent.children,
      best,
      fn child, best_tuple ->
        find_longest_chain(child, path ++ [parent.value], best_tuple)
      end
    )
  end
end
