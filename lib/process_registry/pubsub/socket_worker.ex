defmodule ProcessRegistry.Pubsub.SocketWorker do
  use GenServer

  # API

  def start_link(socket) do
    GenServer.start_link(__MODULE__, [socket: socket])
  end

  # Callbacks

  def init(socket) do
    IO.inspect "Socket Worker init on: #{inspect socket}"
    :gproc.reg({:p, :l, :something})
    {:ok, socket}
  end

  def handle_cast({:msg, msg}, [socket: socket] = state) do
    IO.inspect "Cast msg: #{inspect msg} on socket: #{inspect socket}"
    Socket.Stream.send(socket, msg)
    {:noreply, state}
  end
end
