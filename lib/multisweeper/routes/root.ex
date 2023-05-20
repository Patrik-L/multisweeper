defmodule RootRouter do
  use Plug.Router

  plug(:match)
  plug(CORSPlug, origin: ["http://127.0.0.1:5173"], methods: ["GET", "POST"])

  plug(Plug.Logger)

  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Jason
  )

  # plug(Corsica, origins: "*", allow_methods: ["GET", "POST"])
  plug(:dispatch)

  get "/hello" do
    send_resp(conn, 200, "world")
  end

  forward("/game", to: GameRouter)

  forward("/room", to: RoomRouter)

  match _ do
    send_resp(conn, 404, "oops")
  end
end
