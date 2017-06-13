defmodule ProcessRegistry do

  alias ProcessRegistry.Pool.PoolServer
  alias ProcessRegistry.Action.ActionSupervisor

  def pool_call(worker_id, value) do
    PoolServer.call(worker_key: worker_id, value: value)
  end

  def pool_cast(worker_id, value) do
    PoolServer.cast(worker_key: worker_id, value: value)
  end

  ProcessRegistry.action_start "action id 1", "action value"
  ProcessRegistry.action_start "action id 2", "action value"
  def action_start(action_id, value) do
    ActionSupervisor.start_child(name: action_id, value: value)
  end
end
