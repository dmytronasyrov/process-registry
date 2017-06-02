defmodule ProcessRegistry.Action.ActionServer do
  use GenServer

  alias ProcessRegistry.Registry

  # API

  def start_link(name: name), do: GenServer.start_link(__MODULE__, name, name: via_tuple(name))

  def whereis(name: name), do: Registry.whereis_name({:server, name})

  # Private

  defp via_tuple(name), do: {:via, Registry, {:server, name}}
end
