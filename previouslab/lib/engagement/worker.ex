defmodule Engagement.Worker do
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
    compute_ratio(tweet)
    {:noreply, %{}}
  end

  def decode_id(tweet) do
    decode = Poison.decode!(tweet.data)
    decode["message"]["tweet"]["id"]
  end

  def decode_favorite(tweet) do
    decode = Poison.decode!(tweet.data)
    decode["message"]["tweet"]["user"]["favourites_count"]
  end

  def decode_retweets(tweet) do
    decode = Poison.decode!(tweet.data)
    decode["message"]["tweet"]["retweet_count"]
  end

  def decode_followers(tweet) do
    decode = Poison.decode!(tweet.data)
    decode["message"]["tweet"]["user"]["followers_count"]
  end

  def compute_ratio(tweet) do
    decodedId = decode_id(tweet)
    favorites = decode_favorite(tweet)
    retweets = decode_retweets(tweet)
    followers = decode_followers(tweet)
    count = favorites + retweets
    ratio = count / followers
    send = to_string(decodedId) <> " r " <> to_string(ratio) <> "*^*"
    GenServer.cast(Collector,{:data, send})
 end

end
