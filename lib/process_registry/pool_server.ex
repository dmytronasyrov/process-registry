defmodule ProcessRegistry.PoolServer do
  @pool_size 3

  alias ProcessRegistry.{PoolSupervisor, PoolWorker}

  # API

  def start_link, do: PoolSupervisor.start_link(@pool_size)

  def call(key) do
    choose_worker(key)
    |> PoolWorker.call(key)
  end

  def cast(key, value) do
    choose_worker(key)
    |> PoolWorker.cast(key, value)
  end

  # Private

  defp choose_worker(key), do: :erlang.phash2(key, @pool_size) + 1
end
