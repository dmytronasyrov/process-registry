defmodule ProcessRegistry.Application do
  use Application

  alias ProcessRegistry.{Registry, RegistryETS}
  alias ProcessRegistry.Pool.PoolServer
  alias ProcessRegistry.Action.ActionSupervisor

  # API

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    opts = [strategy: :rest_for_one, name: ProcessRegistry.Supervisor]
    children = [
      worker(Registry, []),
      worker(RegistryETS, []),
      worker(PoolServer, []),
      supervisor(ActionSupervisor, [[key_a: :value_a, key_b: :value_b]])
    ]
    Supervisor.start_link(children, opts)
  end
end
