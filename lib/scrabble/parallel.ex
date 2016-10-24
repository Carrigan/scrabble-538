defmodule Scrabble.Parallel do
  def pmap(collection, func) do
    collection
    |> Enum.map(&(Task.async(fn -> func.(&1) end)))
    |> Enum.map(fn task -> Task.await(task, 1_000_000) end)
  end
end
