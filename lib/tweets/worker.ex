defmodule Tweets.Worker do
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

  def handle_cast({:worker, tweetContent}, _smth) do
    send(tweetContent)
    {:noreply, %{}}
  end

  @spec decode_tweet(
          atom
          | %{
              :data =>
                binary
                | maybe_improper_list(
                    binary | maybe_improper_list(any, binary | []) | byte,
                    binary | []
                  ),
              optional(any) => any
            }
        ) :: any
  def decode_tweet(tweetContent) do
    decode = Poison.decode!(tweetContent.data)
    decode["message"]["tweet"]["text"]
  end

  @spec decode_id(
          atom
          | %{
              :data =>
                binary
                | maybe_improper_list(
                    binary | maybe_improper_list(any, binary | []) | byte,
                    binary | []
                  ),
              optional(any) => any
            }
        ) :: any
  def decode_id(tweetContent) do
    decode = Poison.decode!(tweetContent.data)
    decode["message"]["tweet"]["id"]
  end

  def send(tweetContent) do
    decodedTweet = decode_tweet(tweetContent)
    decodedId = decode_id(tweetContent)
    toSend = to_string(decodedId) <> " t " <> to_string(decodedTweet) <> "*^*"
    GenServer.cast(Collector,{:data, toSend})
  end

end
