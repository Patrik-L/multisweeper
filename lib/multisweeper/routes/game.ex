defmodule GameRouter do
  use Plug.Router
  require Logger

  plug(:match)
  plug(:dispatch)

  # When a user hits the /game/dig endpoint
  post "/dig" do
    # get cellId and roomId from the request body
    %{"cellId" => cellId, "roomId" => roomId} = conn.body_params
    # We try to fetch the room. If it doesn't exist, we simply let the process crash
    {:ok, room} = Room.Registry.lookup(Room.Registry, roomId)
    cells = Room.Manager.getCells(room)

    # We get the clicked id, this is possible, since the cellId is also the index of the cell in the enum
    clickedCell = elem(cells, cellId)

    # We initiate the exploration store required by the findAllEmpties function
    {:ok, exploreStore} = ExplorationStore.exploreStoreStart('')

    # Get all cells revealed after clicking a cell. Often this will only be a single cell,
    # but if we click an empty cell, this will return all other empty cells and their neighbours.
    cellUpdate = Helpers.findAllEmpties(exploreStore, clickedCell, Tuple.to_list(cells))

    # We mark the cell as uncovered so we know what cells to return to the client if they reload the page
    cellUpdate = Enum.map(cellUpdate, fn cell -> %{cell | uncovered: true} end)

    # We convert the cell list to a map
    cellUpdateMap = Map.new(cellUpdate, fn x -> {x.id, x} end)

    # Cleanup the exploration store to avoid leaving processes behind
    ExplorationStore.cleanup(exploreStore)

    # Calculate the new full board state that we pass to the room manager
    updatedCells =
      Enum.map(Tuple.to_list(cells), fn cell ->
        if Map.has_key?(cellUpdateMap, cell.id), do: Map.get(cellUpdateMap, cell.id), else: cell
      end)

    # Set the new board state
    Room.Manager.setCells(room, List.to_tuple(updatedCells))

    # Check if the game has ended, either by the user having hit a bomb; or by them having uncovered all
    # cells that aren't bombs
    gameOver =
      updatedCells
      |> Enum.count(&(&1.uncovered === true || &1.bomb === true))
      |> Kernel.>=(tuple_size(cells))

    Logger.warn("Update: #{inspect(cellUpdateMap)}")

    # Return the updated cells the game status to the client
    jsonResponse = Jason.encode!(%{:cellUpdates => cellUpdate, :gameOver => gameOver})

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, jsonResponse)
  end

  # Catch invalid paths
  match _ do
    send_resp(conn, 404, "Invalid Route")
  end
end
