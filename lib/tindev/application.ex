defmodule Tindev.Application do
  use Application
  require Logger

  def start(_type, _args) do
    children = [
      Plug.Cowboy.child_spec(scheme: :http, plug: Tindev.Endpoint, options: [port: 4001])
    ]

    opts = [strategy: :one_for_one, name: Tindev.Endpoint]
    Logger.info("Servidor iniciado na porta 4001")
    Logger.info("http://localhost:4001")

    Supervisor.start_link(children, opts)
  end
end
