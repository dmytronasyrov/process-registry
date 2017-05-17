defmodule ProcessRegistry.PoolServer do
  @pool_size 3

  alias ProcessRegistry.{PoolSupervisor, PoolWorker}

  # API

  def start_link do
    IO.inspect "PoolServer STARTLINK"
    PoolSupervisor.start_link(@pool_size)
  end

  def call(key) do
    IO.inspect "PoolServer CALL #{inspect key}"
    choose_worker(key)
    |> PoolWorker.call(key)
  end

  def cast(key, value) do
    IO.inspect "PoolServer CAST #{inspect key}   #{inspect value}"
    choose_worker(key)
    |> PoolWorker.cast(key, value)
  end

  # Private

  defp choose_worker(key) do
    IO.inspect "PoolServer CHOOSEWORKER: #{inspect key}   #{inspect :erlang.phash2(key, @pool_size)}"
    :erlang.phash2(key, @pool_size) + 1
  end
end
