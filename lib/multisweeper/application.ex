defmodule Multisweeper.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: Multisweeper.Worker.start_link(arg)
      # {Multisweeper.Worker, arg}
      {Plug.Cowboy, scheme: :http, plug: RootRouter, options: [port: 4000]},
      {Room.Registry, name: Room.Registry}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Multisweeper.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
