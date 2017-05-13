defmodule ProcessRegistry.ServerSupervisor do
  use Supervisor

  # API

  def start_link, do: Supervisor.start_link(__MODULE__, nil, name: __MODULE__)

  def start_child([name: _] = args), do: Supervisor.start_child(__MODULE__, args)

  # Callbacks

  def init(_) do
    IO.inspect "Init ServerSupervisor"

    [worker(Server, [])]
    |> supervise(strategy: :simple_one_for_one)
  end
end
