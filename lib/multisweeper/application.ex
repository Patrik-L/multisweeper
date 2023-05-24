defmodule Multisweeper.Application do
  use Application
  require Logger

  @impl true
  # This is the entry point to the application
  def start(_type, _args) do
    Logger.info("Multisweeper server started on http://localhost:4000")

    # Processes ran by the supervisor
    children = [
      {Plug.Cowboy, scheme: :http, plug: RootRouter, options: [port: 4000]},
      {Room.Registry, name: Room.Registry}
    ]

    # Options for the supervisor
    opts = [strategy: :one_for_one, name: Multisweeper.Supervisor]

    # Starts a supervisor process that ensures all specified children are kept alive
    Supervisor.start_link(children, opts)
  end
end
