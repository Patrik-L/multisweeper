defmodule ExplorationStore do
  use Agent

  def exploreStoreStart(_opt_) do
    Agent.start_link(fn -> %{} end)
  end

  def check(store, key) do
    Agent.get(store, &Map.get(&1, key))
  end

  def explore(store, key) do
    Agent.update(store, &Map.put(&1, key, true))
  end
end
