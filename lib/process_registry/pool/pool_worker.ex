defmodule ProcessRegistry.Pool.PoolWorker do
  use GenServer

  alias ProcessRegistry.{Registry, RegistryETS}

  @registry :gproc

  # API

  def process_id(worker_id), do: {:pool_worker, worker_id}

  def start_link(worker_id) do
    GenServer.start_link(__MODULE__, nil, name: via_tuple(@registry, worker_id))
  end

  def call(worker_id, value) do
    GenServer.call(via_tuple(@registry, worker_id), {:call, value})
  end

  def cast(worker_id, value) do
    GenServer.cast(via_tuple(@registry, worker_id), {:cast, value})
  end

  # Callbacks

  def handle_call({:call, value}, _, state) do
    {:reply, "Call #{inspect self()}, value: #{inspect value}", state}
  end

  def handle_cast({:cast, value}, state) do
    IO.inspect "Cast #{inspect self()}, value: #{inspect value}"
    {:noreply, state}
  end

  # Private

  defp via_tuple(:gproc, worker_id) do
    IO.inspect "Spawn pool worker via gproc"
    {:via, :gproc, {:n, :l, process_id(worker_id)}}
  end
  defp via_tuple(:ets, worker_id) do
    IO.inspect "Spawn pool worker via ETS"
    {:via, RegistryETS, process_id(worker_id)}
  end
  defp via_tuple(:plain, worker_id) do
    IO.inspect "Spawn pool worker via plain registry"
    {:via, Registry, process_id(worker_id)}
  end
end
