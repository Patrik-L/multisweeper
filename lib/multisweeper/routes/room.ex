defmodule RoomRouter do
  use Plug.Router
  require Logger

  plug(:match)
  plug(:dispatch)

  get "/get/:roomId" do
    {:ok, room} = Room.Registry.lookup(Room.Registry, roomId)

    board = Room.Manager.getBoard(room)

    filteredCells =
      Room.Manager.getCells(room)
      |> Tuple.to_list()
      |> Enum.filter(fn cell -> cell.uncovered == true end)

    jsonResponse = Jason.encode!(%{:board => board, :cells => filteredCells})

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, jsonResponse)
  end

  get "/list" do
    send_resp(conn, 200, "list all rooms")
  end

  get "/create/:roomSlug" do
    # get this from boardSize param
    boardSize = 15
    bombs = 8

    ok = Room.Registry.create(Room.Registry, roomSlug, boardSize, bombs)

    jsonResponse = Jason.encode!(%{:ok => ok, :roomId => roomSlug})

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, jsonResponse)
  end

  match _ do
    send_resp(conn, 404, "Invalid Route")
  end
end
