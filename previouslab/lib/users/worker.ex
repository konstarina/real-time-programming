defmodule Users.Worker do
 use GenServer

  def start_link(tweet) do
    GenServer.start_link(__MODULE__, tweet, name: __MODULE__)
  end

  def init(tweet) do
    {:ok, %{name: tweet}}
  end

  def handle_call(:get, _from, state) do
    {:reply, {:ok, state}, state}
  end

  def handle_cast({:worker, tweet}, _msg) do
    send(tweet)
    {:noreply, %{}}
  end

  def send(tweet) do
    decode = Poison.decode!(tweet.data)
    user = decode["message"]["tweet"]["user"]
    username = user["screen_name"]
    decodedId = decode["message"]["tweet"]["id"]
    send = to_string(decodedId) <> " u " <> to_string(username) <> "*^*"
    GenServer.cast(Collector,{:data, send})
    GenServer.cast(DBConnect, {:data, user})
 end


end