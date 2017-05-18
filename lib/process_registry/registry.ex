defmodule ProcessRegistry.Registry do
  use GenServer

  import Kernel, except: [send: 2]

  # API

  def start_link, do: GenServer.start_link(__MODULE__, %{}, name: __MODULE__)

  def register_name(key, pid) do
    GenServer.call(__MODULE__, {:register_name, key, pid})
  end

  def whereis_name(key) do
    GenServer.call(__MODULE__, {:whereis_name, key})
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
    GenServer.cast(__MODULE__, {:unregister_name, name})
  end

  # Callbacks

  def handle_call({:register_name, key, pid}, _, state) do
    case state[key] do
      nil ->
        Process.monitor(pid)
        {:reply, :yes, Map.put(state, key, pid)}

      _ -> {:reply, :no, state}
    end
  end

  def handle_call({:whereis_name, key}, _, state) do
    {:reply, Map.get(state, key, :undefined), state}
  end

  def handle_cast({:unregister_name, key}, state) do
    {:noreply, Map.delete(state, key)}
  end

  def handle_info({:DOWN, _, :process, pid_to_remove, _}, state) do
    pids = Enum.filter(state, fn {_key, pid} ->
      pid != pid_to_remove
    end)
    |> Enum.into(%{})

    {:noreply, pids}
  end
  def handle_info(_, state), do: {:noreply, state}
end
