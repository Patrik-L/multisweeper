# This module keeps track of explored cells when traversing empty cells
defmodule ExplorationStore do
  # Agents are an abstraction of processes that we use here to store state
  use Agent

  # initialize the agent
  def exploreStoreStart(_opt_) do
    Agent.start_link(fn -> %{} end)
  end

  # Check if the exploration store contains a cell with specified key
  def check(store, key) do
    Agent.get(store, &Map.get(&1, key))
  end

  # Marks a cell as explored
  def explore(store, key) do
    Agent.update(store, &Map.put(&1, key, true))
  end

  # Stops the agent and cleans up extra resources
  def cleanup(store) do
    Agent.stop(store)
  end
end
