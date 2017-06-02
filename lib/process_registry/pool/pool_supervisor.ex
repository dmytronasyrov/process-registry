defmodule ProcessRegistry.Pool.PoolSupervisor do
  use Supervisor

  alias ProcessRegistry.Pool.PoolWorker

  # API

  def start_link(pool_size) do
    Supervisor.start_link(__MODULE__, pool_size, name: __MODULE__)
  end

  # Callbacks

  def init(pool_size) do
    for worker_id <- 1..pool_size do
      worker(PoolWorker, [worker_id], id: PoolWorker.process_id(worker_id))
    end |> supervise(strategy: :one_for_one)
  end
end
