defmodule ProcessRegistry.Application do
  use Application

  alias ProcessRegistry.{Registry, RegistryETS}
  alias ProcessRegistry.Pool.PoolServer
  alias ProcessRegistry.Action.ActionSupervisor
  alias ProcessRegistry.Pubsub.SocketListener

  # API

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    opts = [strategy: :rest_for_one, name: ProcessRegistry.Supervisor]
    children = [
      worker(Registry, []),
      worker(RegistryETS, []),
      worker(PoolServer, []),
      supervisor(ActionSupervisor, [[key_a: :value_a, key_b: :value_b]]),
      worker(SocketListener, [9999])
    ]
    sup_tree = Supervisor.start_link(children, opts)

    ProcessRegistry.Router.start_link
    sup_tree
  end
end
