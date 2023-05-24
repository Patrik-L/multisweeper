# This is the root router, in charge of forwarding all incoming traffic
defmodule RootRouter do
  use Plug.Router

  # This is the pipeline all requests go trough
  plug(:match)

  # Adds neccesary headers to avoid CORS problems
  plug(CORSPlug, origin: ["http://127.0.0.1:5173"], methods: ["GET", "POST"])

  # Log all requests
  plug(Plug.Logger)

  # Parse all incoming body data as json
  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Jason
  )

  plug(:dispatch)

  # Informative root page
  get "/" do
    send_resp(conn, 404, "There's nothing here.\nCurrently available endpoints:
    POST: /game/dig
    GET: /room/get/:roomId  /room/create/:roomId")
  end

  # Forward traffic to different routes to sub-routers
  forward("/game", to: GameRouter)
  forward("/room", to: RoomRouter)

  # Catching invalid routes
  match _ do
    send_resp(conn, 404, "Route not found!")
  end
end
