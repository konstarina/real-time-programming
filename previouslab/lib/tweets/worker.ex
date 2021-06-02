defmodule Tweets.Worker do
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

  def decode_id(tweet) do
    decode = Poison.decode!(tweet.data)
    decode["message"]["tweet"]["id"]
  end

  def decode_tweet(tweet) do
    decode = Poison.decode!(tweet.data)
    decode["message"]["tweet"]["text"]
  end

  def send(tweet) do
    decoded = decode_tweet(tweet)
    decodedId = decode_id(tweet)
    send = to_string(decodedId) <> " s " <> to_string(decoded) <> "*^*"
    GenServer.cast(Collector, {:data, send})
  end

end
