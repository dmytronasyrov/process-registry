defmodule ProcessRegistry.Application do
  use Application

  alias ProcessRegistry.Registry
  alias ProcessRegistry.Pool.PoolServer
  alias ProcessRegistry.Action.ActionSupervisor

  # API

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    opts = [strategy: :rest_for_one, name: ProcessRegistry.Supervisor]
    [worker(Registry, []), worker(PoolServer, []), worker(ActionSupervisor, [])]
    |> Supervisor.start_link(opts)
  end
end
