defmodule KVServer do
  require Logger

  def init(arg) do
    {:ok, arg}
  end

  def accept(port) do
    {:ok, socket} = :gen_tcp.listen(port, [:binary, active: false, reuseaddr: true])
    Logger.info("Broker listening on #{port}")
    GenServer.start_link(__MODULE__, %{subscribtionStatus: false}, [name: {:global, {:name, "Broker"}}])

    loop_acceptor(socket)
  end

  defp loop_acceptor(socket) do
    {:ok, client} = :gen_tcp.accept(socket)
    serve(client)
    loop_acceptor(socket)
  end

  def serve(:error, _) do

  end

  def serve(body, socket) do
    decoded_message = Poison.decode!(body)
    if decoded_message["type"] != nil and decoded_message["type"] =~ "subscribe" do
      Register.add(decoded_message["topic"] || "all", socket)
    end

    serve(socket)
  end

  def send_socket(socket, data) do
    try do
      :gen_tcp.send(socket, data)
    rescue
      _ -> IO.puts("Something went wrong")
    end
  end

  def handle_cast({:subscribe_to_tweets, data}, state) do
    # state = true;

    {:noreply, state}
  end

  def handle_cast({:unsubscribe, data}, state) do
    state = false;

    {:noreply, state}
  end

  def handle_cast({:receive_tweets, data}, state) do
    if state === true do
      IO.inspect(data)
    end

    {:noreply, state}
  end

  def handle_cast({:publish, data}, state) do

    {:ok, parsedData} = Poison.decode(data)
    IO.puts("received publish call; #{data};")
    emit(parsedData["username"], data)
    emit("all", data)

    {:noreply, state}
  end

  def serve(socket) do
    body =  try do
      {:ok, body} = :gen_tcp.recv(socket, 0)
      body
    rescue
      _ -> :error
    end
    serve(body, socket)
  end


  def emit(topic, value) do
    # IO.inspect(value)
    clients = Register.get(topic)
    IO.puts("should emit #{value}")
    for client <- clients  do
      send_socket(client, value)
    end

  end
end
