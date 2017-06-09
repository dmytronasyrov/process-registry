defmodule ProcessRegistry.Pool.PoolWorker do
  use GenServer

  alias ProcessRegistry.{Registry, RegistryETS}

  # API

  def process_id(worker_id), do: {:pool_worker, worker_id}

  def start_link(worker_id) do
    GenServer.start_link(__MODULE__, nil, name: via_tuple(worker_id))
  end

  def call(worker_id, value) do
    GenServer.call(via_tuple(worker_id), {:call, value})
  end

  def cast(worker_id, value) do
    GenServer.cast(via_tuple(worker_id), {:cast, value})
  end

  # Callbacks

  def handle_call({:call, value}, _, state) do
    IO.inspect "Call #{inspect self()}, value: #{inspect value}"
    {:reply, :ok, state}
  end

  def handle_cast({:cast, value}, state) do
    IO.inspect "Cast #{inspect self()}, value: #{inspect value}"
    {:noreply, state}
  end

  # Private

  defp via_tuple(worker_id), do: {:via, RegistryETS, process_id(worker_id)}
end
