defmodule Helpers do
  require Logger

  @callback calculateValue(Cell, [Cell]) :: any
  # Calculates the value of the cell by getting the amount of bombs in the surrounding cells
  def calculateValue(cell, cells) do
    Enum.filter(getSurroundingCells(cell, cells), &(&1.bomb == true)) |> Enum.count()
  end

  # Finds all 8 surrounding cells and the original cell given the original cell and cell array containing all cells
  def getSurroundingCells(cell, cells) do
    # We get the difference of the x and y locations of the target and original cell.
    # If the difference is smaller than 2, then we know it is a surrounding cell.
    val =
      Enum.filter(cells, fn target ->
        abs(target.location.x - cell.location.x) < 2 &&
          abs(target.location.y - cell.location.y) < 2
      end)

    val
  end

  # Finds all empty cells connected to clicked cell, returns only the original cell if it is not empty
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

  # Returns specified amount of random indexes in range
  def getRandomIndexesInRange(elements, randomElementNumber) do
    if(randomElementNumber > 0) do
      # Get random element of range
      randomElement = Enum.random(elements)
      # Filter out the picked element
      remainingElements = Enum.filter(elements, fn element -> element != randomElement end)
      # Recursively call same function, this time asking for 1 element less.
      # After this we return all results as a single array
      [randomElement | getRandomIndexesInRange(remainingElements, randomElementNumber - 1)]
    else
      []
    end
  end
end
