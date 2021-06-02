defmodule Router do
  use GenServer

  def start_link(message) do
    GenServer.start_link(__MODULE__, message, name: __MODULE__)
  end

  @impl true
  def init(message) do
    {:ok, message}
  end

  @impl true
  def handle_cast({:router, message}, state) do
    Sentiments.Supervisor.addWorker(message)
    GenServer.cast(Sentiments.Worker, {:worker, message})
    Tweets.Supervisor.addWorker(message)
    GenServer.cast(Tweets.Worker, {:worker, message})
    Users.Supervisor.addWorker(message)
    GenServer.cast(Users.Worker, {:worker, message})
    Engagement.Supervisor.addWorker(message)
    GenServer.cast(Engagement.Worker, {:worker, message})
    {:noreply, state}
  end
end