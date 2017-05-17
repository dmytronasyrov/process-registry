defmodule ProcessRegistry.PoolWorker do
  use GenServer

  alias ProcessRegistry.Registry

  # API

  def process_id(worker_id), do: {:pool_worker, worker_id}

  def start_link(worker_id) do
    IO.puts "PoolWorker START: #{inspect worker_id}"
    GenServer.start_link(__MODULE__, nil, name: via_tuple(worker_id))
  end

  def call(worker_id, key) do
    IO.puts "PoolWorker CALL: #{inspect worker_id}   #{inspect key}"
    GenServer.call(via_tuple(worker_id), {:call, key})
  end

  def cast(worker_id, key, value) do
    IO.puts "PoolWorker CAST: #{inspect worker_id}   #{inspect key}   #{inspect value}"
    GenServer.cast(via_tuple(worker_id), {:cast, key, value})
  end

  # Callbacks

  def handle_call({:call, key}, _, state) do
    IO.puts "PoolWorker HANDLECALL: #{inspect key}"
    {:reply, :ok, state}
  end

  def handle_cast({:cast, key, value}, state) do
    IO.puts "PoolWorker HANDLECAST: #{inspect key}   #{inspect value}"
    {:noreply, state}
  end

  # Private

  defp via_tuple(worker_id), do: {:via, Registry, process_id(worker_id)}
end
