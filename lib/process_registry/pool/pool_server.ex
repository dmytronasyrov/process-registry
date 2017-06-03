defmodule ProcessRegistry.Pool.PoolServer do
  @pool_size 3

  alias ProcessRegistry.Pool.{PoolSupervisor, PoolWorker}

  # API

  def start_link, do: PoolSupervisor.start_link(@pool_size)

  def call(worker_key: worker_key, value: value) do
    choose_worker(worker_key)
    |> PoolWorker.call(value)
  end

  def cast(worker_key: worker_key, value: value) do
    choose_worker(worker_key)
    |> PoolWorker.cast(value)
  end

  # Private

  defp choose_worker(worker_key), do: :erlang.phash2(worker_key, @pool_size) + 1
end
