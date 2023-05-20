defmodule Room.Registry do
  use GenServer
  require Logger

  Logger.info("super")
  ## Client API

  @doc """
  Starts the registry.
  """
  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  @doc """
  Looks up the bucket pid for `name` stored in `server`.

  Returns `{:ok, pid}` if the bucket exists, `:error` otherwise.
  """
  def lookup(server, name) do
    GenServer.call(server, {:lookup, name})
  end

  @doc """
  Ensures there is a bucket associated with the given `name` in `server`.
  """
  def create(server, name, boardSize, bombChance) do
    GenServer.cast(server, {:create, name, boardSize, bombChance})
  end

  ## Defining GenServer Callbacks

  @impl true
  def init(:ok) do
    {:ok, %{}}
  end

  @impl true
  def handle_call({:lookup, name}, _from, names) do
    {:reply, Map.fetch(names, name), names}
  end

  @impl true
  def handle_cast({:create, name, boardSize, bombChance}, names) do
    if Map.has_key?(names, name) do
      {:noreply, names}
    else
      {:ok, room} = Room.Manager.createRoom(boardSize, bombChance)
      {:noreply, Map.put(names, name, room)}
    end
  end
end
