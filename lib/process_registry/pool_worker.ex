defmodule ProcessRegistry.PoolWorker do
  use GenServer

  alias ProcessRegistry.Registry

  # API

  def process_id(worker_id), do: {:pool_worker, worker_id}

  def start_link(worker_id) do
    GenServer.start_link(__MODULE__, nil, name: via_tuple(worker_id))
  end

  def call(worker_id, key) do
    GenServer.call(via_tuple(worker_id), {:call, key})
  end

  def cast(worker_id, key, value) do
    GenServer.cast(via_tuple(worker_id), {:cast, key, value})
  end

  # Callbacks

  def handle_call({:call, _key}, _, state) do
    {:reply, :ok, state}
  end

  def handle_cast({:cast, _key, _value}, state) do
    {:noreply, state}
  end

  # Private

  defp via_tuple(worker_id), do: {:via, Registry, process_id(worker_id)}
end
