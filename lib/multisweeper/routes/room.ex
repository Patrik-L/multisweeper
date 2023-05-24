defmodule RoomRouter do
  use Plug.Router
  require Logger

  plug(:match)
  plug(:dispatch)
  # When a user hits the /game/get/:roomId endpoint
  get "/get/:roomId" do
    # We get the room determined by the id fetched from the path
    {:ok, room} = Room.Registry.lookup(Room.Registry, roomId)
    board = Room.Manager.getBoard(room)

    # Get all uncovered cells
    filteredCells =
      Room.Manager.getCells(room)
      |> Tuple.to_list()
      |> Enum.filter(fn cell -> cell.uncovered == true end)

    # We return all uncovered cells to the user as well as the board with cell ids
    jsonResponse = Jason.encode!(%{:board => board, :cells => filteredCells})

    # We have to format the response as application/json
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, jsonResponse)
  end

  # When a user hits the /game/create/:roomSlug endpoint
  get "/create/:roomSlug" do
    # Board size and bomb amount, these can be edited as needed
    boardSize = 15
    bombs = 30

    # Create a new room
    ok = Room.Registry.create(Room.Registry, roomSlug, boardSize, bombs)

    # Return if room creation succeeded as well as the room id
    jsonResponse = Jason.encode!(%{:ok => ok, :roomId => roomSlug})

    # We have to format the response as application/json
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, jsonResponse)
  end

  # Catch invalid paths
  match _ do
    send_resp(conn, 404, "Invalid Route")
  end
end
