defmodule Worker do
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
    print_tweet(tweet)
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

  def print_tweet(tweet) do
    decoded = decode_tweet(tweet)
    evaluated = evaluate(decoded)

    if tweet.data =~ "panic" do
      IO.inspect("Panic message")
      else
      IO.inspect(evaluated)
    end
 end


end