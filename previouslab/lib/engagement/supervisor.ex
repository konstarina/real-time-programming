defmodule Engagement.Supervisor do
  use DynamicSupervisor

  def start_link(_arg) do
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @impl true
  def init(:ok) do
     DynamicSupervisor.init(strategy: :one_for_one)
  end

  def addWorker(message) do
    child_spec = {Engagement.Worker, {message}}

    DynamicSupervisor.start_child(__MODULE__, child_spec)
  end

  def killWorker(worker_pid) do
    DynamicSupervisor.terminate_child(__MODULE__, worker_pid)
  end

  def castMessage(message) do
    GenServer.cast(Engagement.Worker, {:worker, message})
  end
end