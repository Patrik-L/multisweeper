defmodule Room.Registry do
  # We use a genServer to keep track of all room processes
  use GenServer
  require Logger

  Logger.info("super")

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  # Looks up the room pid for `name` stored in `server`.
  def lookup(server, name) do
    GenServer.call(server, {:lookup, name})
  end

  # Creates a new room
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
