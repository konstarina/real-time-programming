defmodule Main.Main do
  @moduledoc false
  


  use Application

  def start(_type, _args) do

    children = [
      %{
        id: Worker,
        start: {Worker, :start_link, [""]}
      },
      %{
        id: DynamicSupervisor,
        start: {DynamicSupervisor, :start_link, [""]}
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

    Main.Supervisor.start_link(children, opts)
  end
end