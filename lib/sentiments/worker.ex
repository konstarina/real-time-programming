defmodule Sentiments.Worker do
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

  def decode_tweet(tweet) do
    chars = [",", ".", "?", ":", "!"]
    decode = Poison.decode!(tweet.data)
    decode["message"]["tweet"]["text"]
          |> String.replace(chars, "")
          |> String.split(" ", trim: true)
  end

  def evaluate(eval) do
    eval
    |> Enum.reduce(0, fn values, acc -> Emotions.get_emotions(values) + acc end)
    |> Kernel./(length(eval))
  end

  def decode_id(tweet) do
    decode = Poison.decode!(tweet.data)
    decode["message"]["tweet"]["id"]
 end

  def send(tweet) do
    decoded = decode_tweet(tweet)
    decodedId = decode_id(tweet)
    evaluated = evaluate(decoded)
    send = to_string(decodedId) <> " s " <> to_string(evaluated) <> "*^*"
    GenServer.cast(Collector, {:data, send})
 end

end