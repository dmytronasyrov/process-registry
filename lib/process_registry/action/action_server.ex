defmodule ProcessRegistry.Action.ActionServer do
  use GenServer

  alias ProcessRegistry.{Registry, RegistryETS}

  # API

  def start_link(args_init, args) do
    IO.inspect "Action start_link initial args: #{inspect args_init}"
    [name: name, value: value] = args
    GenServer.start_link(__MODULE__, value, name: via_tuple(name))
  end

  def whereis(name: name), do: RegistryETS.whereis_name({:action_server, name})

  # Callbacks

  def init(state) do
    IO.inspect "Action Init state: #{inspect state}"
    {:ok, state}
  end

  # Private

  defp via_tuple(name), do: {:via, RegistryETS, {:action_server, name}}
end
