defmodule ProcessRegistry.RegistryETS do
  use GenServer

  import Kernel, except: [send: 2]

  # API

  def start_link, do: GenServer.start_link(__MODULE__, nil, name: __MODULE__)

  def register_name(key, pid) do
    GenServer.call(__MODULE__, {:register_name, key, pid})
  end

  def whereis_name(key) do
    case :ets.lookup(__MODULE__, key) do
      [{^key, pid}] -> pid
      _ -> :undefined
    end
  end

  def send(key, message) do
    case whereis_name(key) do
      :undefined -> {:badarg, {key, message}}
      pid ->
        Kernel.send(pid, message)
        pid
    end
  end

  defp unregister_name(key) do
    GenServer.cast(__MODULE__, {:unregister_name, key})
  end

  # Callbacks

  def init(_) do
    :ets.new(__MODULE__, [:named_table, :protected, :set])
    {:ok, nil}
  end

  def handle_call({:register_name, key, pid}, _, state) do
    case whereis_name(key) do
      :undefined ->
        :ets.insert(__MODULE__, {key, pid})
        Process.monitor(pid)
        {:reply, :yes, state}

      _ -> {:reply, :no, state}
    end
  end

  def handle_cast({:unregister_name, key}, state) do
    :ets.match_delete(__MODULE__, key)
    {:noreply, state}
  end

  def handle_info({:DOWN, _, :process, pid_to_remove, _}, state) do
    :ets.match_delete(__MODULE__, {:_, pid_to_remove})
    {:noreply, state}
  end
  def handle_info(_, state), do: {:noreply, state}
end
