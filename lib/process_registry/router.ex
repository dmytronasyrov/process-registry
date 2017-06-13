defmodule ProcessRegistry.Router do
  use Plug.Router

  alias ProcessRegistry.Pool.PoolServer

  plug :match
  plug :dispatch

  # API

  def start_link do
    case Application.get_env(:process_registry, :port) do
      nil -> start_cowboy(5454)
      port -> start_cowboy(port)
    end
  end

  # curl "http://localhost:8888/call?worker_key=worker1&value=aaa"
  get "/call" do
    conn
    |> Plug.Conn.fetch_query_params
    |> call
    |> respond
  end

  match _, do: send_resp(conn, 404, "Page Not Found")

  # Private

  defp start_cowboy(port) do
    IO.inspect "Starting Cowboy on #{inspect port}"
    Plug.Adapters.Cowboy.http(__MODULE__, nil, port: port)
  end

  defp stop_cowboy do
    IO.inspect "Shutting down Cowboy"
    Plug.Adapters.Cowboy.shutdown(__MODULE__)
  end
  
  defp call(conn) do
    %{"worker_key" => worker_id, "value" => value} = conn.params

    response = [worker_key: worker_id, value: value]
    |> PoolServer.call

    Plug.Conn.assign(conn, :response, response)
  end

  defp respond(conn) do
    conn
    |> Plug.Conn.put_resp_content_type("text/plain")
    |> Plug.Conn.send_resp(200, conn.assigns[:response])
  end
end
