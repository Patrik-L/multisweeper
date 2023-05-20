defmodule Helpers do
  @callback calculateValue(Cell, [Cell]) :: any
  def calculateValue(cell, cells) do
    Enum.filter(cells, fn target ->
      abs(target.location.x - cell.location.x) <= 1 &&
        abs(target.location.y - cell.location.y) <= 1 &&
        target.bomb == true
    end)
    |> Enum.count()
  end
end
