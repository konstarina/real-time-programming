defmodule Tweet.Main do
  @moduledoc false
  use Application
  require Logger

  @impl true
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    Node.connect(:"broker@localhost")
    Logger.info("connected to broker")

    children = [
      %{
        id: Publisher.Supervisor,
        start: {Publisher.Supervisor, :start_link, [""]}
      },
      %{
        id: Database,
        start: {Database, :start_link, [""]}
      },
      %{
        id: Collector,
        start: {Collector, :start_link, []}
      },
      %{
        id: Sentiments.Supervisor,
        start: {Sentiments.Supervisor, :start_link, [""]}
      },

      %{
        id: Tweets.Supervisor,
        start: {Tweets.Supervisor, :start_link, [""]}
      },

      %{
        id: Users.Supervisor,
        start: {Users.Supervisor, :start_link, [""]}
      },

      %{
        id: Engagement.Supervisor,
        start: {Engagement.Supervisor, :start_link, [""]}
      },
      %{
        id: Router,
        start: {Router, :start_link, [""]}
      },
      %{
        id: Connection1,
        start: {Connection, :start_link, ["http://localhost:4000/tweets/1"]}
      },
      %{
        id: Connection2,
        start: {Connection, :start_link, ["http://localhost:4000/tweets/2"]}
      },
    ]
    opts = [strategy: :one_for_one, name: Tweet.Supervisor]

    Supervisor.start_link(children, opts)
  end
end
