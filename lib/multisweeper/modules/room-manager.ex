defmodule Room.Manager do
  # Agents are an abstraction of processes that we use here to store state
  use Agent
  require Logger

  # Creates a room and stores it's process into the room registry
  def createRoom(boardSize \\ 10, bombs \\ 10) do
    cellsToGenerate = boardSize ** 2
    bombIndexes = Helpers.getRandomIndexesInRange(0..cellsToGenerate, bombs)

    Logger.info("Bomb Locations: #{inspect(bombIndexes)}")

    # Generates all cells as a single list
    cells =
      0..(cellsToGenerate - 1)
      |> Enum.map(fn index ->
        %Cell{
          id: index,
          location: %{
            :x => rem(index, boardSize),
            :y => floor(index / boardSize)
          },
          bomb: Enum.member?(bombIndexes, index),
          uncovered: false
        }
      end)

    # Generates the board by chucking the cells into rows and getting their ids
    board = cells |> Enum.map(fn cell -> cell.id end) |> Enum.chunk_every(boardSize)

    # Calculates the values of each cell
    cells = cells |> Enum.map(fn cell -> %{cell | value: Helpers.calculateValue(cell, cells)} end)

    # Specifies the initial state of the agent to contain the board as a list and cells as a tuple
    Agent.start_link(fn -> %{:board => board, :cells => List.to_tuple(cells)} end)
  end

  def getBoard(room) do
    Agent.get(room, &Map.get(&1, :board))
  end

  @spec getCells(atom | pid | {atom, any} | {:via, atom, any}) :: any
  def getCells(room) do
    Agent.get(room, &Map.get(&1, :cells))
  end

  def setCells(room, cells) do
    Agent.update(room, &Map.put(&1, :cells, cells))
  end
end
