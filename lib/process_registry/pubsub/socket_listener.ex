# telnet 127.0.0.1 9999

defmodule ProcessRegistry.Pubsub.SocketListener do

  alias ProcessRegistry.Pubsub.SocketWorker

  # API

  def start_link(port) do
    pid = spawn_link(fn -> init(port) end)
    {:ok, pid}
  end

  # Callbacks

  def init(port) do
    port
    |> Socket.TCP.listen!(packet: :line)
    |> loop
  end

  # Private

  defp loop(port) do
    IO.inspect "Socket Listener init on: #{inspect port}"
    listener_pid = port |> Socket.TCP.accept!
    spawn(fn() -> init_worker(listener_pid) end)
    loop(port)
  end

  defp init_worker(listener_pid) do
    {:ok, worker_pid} = SocketWorker.start_link(listener_pid)
    IO.inspect "Worker started with: #{inspect worker_pid}"
    received(listener_pid)
  end

  defp received(listener_pid) do
    case Socket.Stream.recv(listener_pid) do
      {:ok, nil} ->
        IO.inspect "Data received and nil"
        received(listener_pid)

      {:ok, data} ->
        IO.inspect "Data received: #{inspect data}"
        GenServer.cast({:via, :gproc, {:p, :l, :socket_listener}}, {:msg, data})
        received(listener_pid)

      {:error, :closed} ->
        IO.inspect "Connection closed"
        :ok

      {:error, :ebadf} ->
        IO.inspect "Connection halted"
        :ok

      other -> IO.inspect("OTHER: #{inspect other}")
    end
  end
end
