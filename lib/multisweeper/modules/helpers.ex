defmodule Helpers do
  require Logger

  @callback calculateValue(Cell, [Cell]) :: any
  def calculateValue(cell, cells) do
    Enum.filter(getSurroundingCells(cell, cells), &(&1.bomb == true)) |> Enum.count()
  end

  def getSurroundingCells(cell, cells) do
    val =
      Enum.filter(cells, fn target ->
        abs(target.location.x - cell.location.x) <= 1 &&
          abs(target.location.y - cell.location.y) <= 1
      end)

    val
  end

  def findAllEmpties(exploreStore, cell, cells) do
    # Marks cell as explored
    ExplorationStore.explore(exploreStore, cell.id)

    # Check if the cell is empty
    if(cell.value === 0) do
      # remove already searched cells from to-be-searched cells
      cells = Enum.filter(cells, fn x -> !ExplorationStore.check(exploreStore, x.id) end)

      # We call findAllEmpties recursively on all surrounding cells
      exploratoryArrays =
        Enum.map(getSurroundingCells(cell, cells), fn surroundingCell ->
          findAllEmpties(exploreStore, surroundingCell, cells)
        end)

      # Exploratory arrays is a list of all results, we combine them together to get all explored cells
      exploredCells = Enum.concat(exploratoryArrays)

      # Prepend current cell to explored cells
      [cell | exploredCells]
    else
      # We return the cell without exploring further if it wasn't empty
      [cell]
    end
  end

  def getRandomIndexesInRange(elements, randomElementNumber) do
    if(randomElementNumber > 0) do
      randomElement = Enum.random(elements)
      remainingElements = Enum.filter(elements, fn element -> element != randomElement end)
      [randomElement | getRandomIndexesInRange(remainingElements, randomElementNumber - 1)]
    else
      []
    end
  end
end
