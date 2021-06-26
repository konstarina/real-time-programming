defmodule BrokerModule do
  require Logger
  use Application

  @impl true
  def start(_type, _args) do

    children = [
      %{
        id: Register,
        start: {Register, :init, []}
      },
      %{
        id: KVServer,
        start: {KVServer, :accept, [4040]}
      }
    ]

    opts = [strategy: :one_for_one]
    Supervisor.start_link(children, opts)
  end
end
