defmodule RoomRouter do
  use Plug.Router
  require Logger

  plug(:match)
  plug(:dispatch)

  get "/get/:roomId" do
    {:ok, room} = Room.Registry.lookup(Room.Registry, roomId)

    result = Room.Manager.getBoard(room)

    jsonResponse = Jason.encode!(%{:board => result})

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, jsonResponse)
  end

  get "/list" do
    send_resp(conn, 200, "list all rooms")
  end

  get "/create/:roomSlug" do
    # get this from boardSize param
    boardSize = 10
    bombChance = 10

    ok = Room.Registry.create(Room.Registry, roomSlug, boardSize, bombChance)

    jsonResponse = Jason.encode!(%{:ok => ok, :roomId => roomSlug})

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, jsonResponse)
  end

  match _ do
    send_resp(conn, 404, "Invalid Route")
  end
end
