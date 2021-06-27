defmodule Publisher.Worker do
  use GenServer

  def init(tweetContent) do
    {:ok,%{name: tweetContent}}
  end

  def start_link(tweetContent) do
    GenServer.start_link(__MODULE__, tweetContent, name: __MODULE__)
  end

  def handle_call(:get, _from, state) do
    {:reply, {:ok, state}, state}
  end

  def handle_cast({:data, tweetContent}, _smth) do
    send(tweetContent)
    {:noreply, %{}}
  end

  def send(tweetContent) do
    {:ok, data} = tweetContent |> Poison.encode
    GenServer.cast({:global, {:name, "Broker"}}, {:publish, data})
  end
end
