defmodule ProcessRegistry.Registry do
  use GenServer

  # API

  def start_link, do: GenServer.start_link(__MODULE__, nil, name: __MODULE__)
end
