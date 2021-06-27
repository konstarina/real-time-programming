defmodule Connection do
  @moduledoc false
  def start_link(url) do
    {:ok, _pid} = EventsourceEx.new(url, stream_to: self())
    getTweet()
  end

  def getTweet() do
    receive do
      tweet -> tweetBehaviour(tweet)
    end
    getTweet()
  end

  def tweetBehaviour(tweet) do
    GenServer.cast(Router, {:router, tweet})
    getTweet()
  end

  def child_spec(opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [opts]},
      type: :worker,
      restart: :permanent,
      shutdown: 250
    }
  end
end
