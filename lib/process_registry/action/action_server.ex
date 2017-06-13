defmodule ProcessRegistry.Action.ActionServer do
  use GenServer

  alias ProcessRegistry.{Registry, RegistryETS}

  @registry :gproc

  # API

  def start_link(args_init, args) do
    IO.inspect "Action start_link initial args: #{inspect args_init}"
    [name: name, value: value] = args
    GenServer.start_link(__MODULE__, value, name: via_tuple(@registry, name))
  end

  def whereis(name: name) do
    case @registry do
      :plain -> Registry.whereis_name({:action_server, name})
      :ets -> RegistryETS.whereis_name({:action_server, name})
      :gproc -> :gproc.where({:n, :l, name})
    end
  end

  # Callbacks

  def init(state), do: {:ok, state}

  # Private

  defp via_tuple(:gproc, name) do
    IO.inspect "Spawn action via gproc"
    {:via, :gproc, {:n, :l, {:action_server, name}}}
  end
  defp via_tuple(:ets, name) do
    IO.inspect "Spawn action via ETS"
    {:via, RegistryETS, {:action_server, name}}
  end
  defp via_tuple(:plain, name) do
    IO.inspect "Spawn action via plain registry"
    {:via, Registry, {:action_server, name}}
  end
end
