defmodule ProcessRegistry do

  alias ProcessRegistry.Pool.PoolServer

  def pool_call(worker_id, value) do
    PoolServer.call(worker_id, value)
  end

  def pool_cast(worker_id, value) do
    PoolServer.cast(worker_id, value)
  end
end
