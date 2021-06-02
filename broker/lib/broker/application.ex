defmodule Broker.Application do
  @moduledoc false
  


  use Application

  def start(_type, _args) do
    children = [
      Supervisor.child_spec({Task, fn -> MyRegistry.start end}, id: MyRegistry),
      {Task.Supervisor, name: Server.TaskSupervisor},
      Supervisor.child_spec({Task, fn -> Server.accept(4444) end}, id: Server)
    ]

    opts = [strategy: :one_for_one, name: Server.Supervisor]
    Application.Supervisor.start_link()
  end
end