defmodule ProcessRegistry.Action.ActionSupervisor do
  use Supervisor

  alias ProcessRegistry.Action.ActionServer

  # API

  def start_link, do: Supervisor.start_link(__MODULE__, nil, name: __MODULE__)

  def start_child([name: _] = args), do: Supervisor.start_child(__MODULE__, args)

  # Callbacks

  def init(_) do
    [worker(ActionServer, [])]
    |> supervise(strategy: :simple_one_for_one)
  end
end
