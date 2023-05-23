defmodule GameRouter do
  use Plug.Router
  require Logger

  plug(:match)

  plug(:dispatch)

  post "/dig" do
    %{"cellId" => cellId, "roomId" => roomId} = conn.body_params
    {_, room} = Room.Registry.lookup(Room.Registry, roomId)
    cells = Room.Manager.getCells(room)

    clickedCell = elem(cells, cellId)

    {:ok, exploreStore} = ExplorationStore.exploreStoreStart('')

    cellUpdate = Helpers.findAllEmpties(exploreStore, clickedCell, Tuple.to_list(cells))

    cellUpdate = Enum.map(cellUpdate, fn cell -> %{cell | uncovered: true} end)

    cellUpdateMap = Map.new(cellUpdate, fn x -> {x.id, x} end)

    updatedCells =
      Enum.map(Tuple.to_list(cells), fn cell ->
        if Map.has_key?(cellUpdateMap, cell.id), do: Map.get(cellUpdateMap, cell.id), else: cell
      end)

    gameOver =
      updatedCells
      |> Enum.count(&(&1.uncovered === true || &1.bomb === true))
      |> Kernel.>=(tuple_size(cells))

    Logger.warn("Update: #{inspect(cellUpdateMap)}")

    Room.Manager.setCells(room, List.to_tuple(updatedCells))

    # TODO: return a cell update array
    jsonResponse = Jason.encode!(%{:cellUpdates => cellUpdate, :gameOver => gameOver})

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, jsonResponse)
  end

  post "/flag" do
    send_resp(conn, 200, "flag set")
  end

  match _ do
    send_resp(conn, 404, "Invalid Route")
  end
end
