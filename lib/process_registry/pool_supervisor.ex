defmodule ProcessRegistry.PoolSupervisor do
  use Supervisor

  alias ProcessRegistry.PoolWorker

  # API

  def start_link(pool_size) do
    Supervisor.start_link(__MODULE__, pool_size, name: __MODULE__)
  end

  # Callbacks

  # {
  #   {:pool_worker, 1},
  #   {ProcessRegistry.PoolWorker, :start_link, [1]},
  #   :permanent,
  #   5000,
  #   :worker,
  #   [ProcessRegistry.PoolWorker]
  # }
  def init(pool_size) do
    IO.inspect "PoolSupervisor INIT"

    processes = for worker_id <- 1..pool_size do
      worker(PoolWorker, [worker_id], id: PoolWorker.process_id(worker_id))
    end
    IO.inspect "PROCESSES: #{inspect processes}"
    supervise(processes, strategy: :one_for_one)
  end
end
