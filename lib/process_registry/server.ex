defmodule ProcessRegistry.Server do
  use GenServer

  # API

  def start_link(name: name), do: GenServer.start_link(__MODULE__, name, name: via_tuple(name))

  def whereis(name: name), do: Registry.whereis_name({:server, name})

  # Callbacks

  def init(_) do
    IO.inspect "Init Server"
    {:ok, nil}
  end

  # Private

  defp via_tuple(name), do: {:via, Registry, {:server, name}}
end
