defmodule ProcessRegistry.Action.ActionSupervisor do
  use Supervisor

  alias ProcessRegistry.Action.ActionServer

  # API

  def start_link(args), do: Supervisor.start_link(__MODULE__, args, name: __MODULE__)

  def start_child([name: _, value: _] = args) do
    Supervisor.start_child(__MODULE__, [args])
  end

  # Callbacks

  def init(args) do
    children = [
      worker(ActionServer, [args], restart: :temporary)
    ]
    supervise(children, strategy: :simple_one_for_one)
  end
end
