defmodule Room.Manager do
  use Agent
  require Logger

  def createRoom(boardSize \\ 10, bombs \\ 10) do
    cellsToGenerate = boardSize ** 2

    bombIndexes = Helpers.getRandomIndexesInRange(0..cellsToGenerate, bombs)

    Logger.info("Bomb Locations: #{inspect(bombIndexes)}")

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

    board = cells |> Enum.map(fn cell -> cell.id end) |> Enum.chunk_every(boardSize)

    cells = cells |> Enum.map(fn cell -> %{cell | value: Helpers.calculateValue(cell, cells)} end)

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

  # def setBoard(room, key, value) do
  #   Agent.update(:rooms, &Map.put(&1, key, value))
  # end
end
