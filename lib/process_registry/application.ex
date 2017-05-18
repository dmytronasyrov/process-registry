defmodule ProcessRegistry.Application do
  use Application

  alias ProcessRegistry.{Registry, PoolServer}

  # API

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Registry, []),
      worker(PoolServer, []),
    ]
    opts = [strategy: :one_for_one, name: ProcessRegistry.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
