defmodule GameRouter do
  use Plug.Router
  require Logger

  plug(:match)

  plug(:dispatch)

  post "/dig" do
    %{"cellId" => cellId, "roomId" => roomId} = conn.body_params
    {_, room} = Room.Registry.lookup(Room.Registry, roomId)
    cells = Room.Manager.getCells(room)

    cell = elem(cells, cellId)

    # TODO: return a cell update array
    jsonResponse = Jason.encode!(%{:cellUpdates => [cell]})

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, jsonResponse)
  end

  post "/flag" do
    send_resp(conn, 200, "flag set")
  end

  get "/gameboard" do
    send_resp(conn, 200, "get gameboard")
  end

  match _ do
    send_resp(conn, 404, "Invalid Route")
  end
end
