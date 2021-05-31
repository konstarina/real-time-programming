defmodule Router do
  use GenServer

  def start_link(message) do
    GenServer.start_link(__MODULE__, message, name: __MODULE__)
  end

  @impl true
  def init(message) do
    {:ok, message}
  end

#  def handle_call(_msg, _from, state) do
#    {:reply, :ok, state}
#  end

  @impl true
  def handle_cast({:router, message}, state) do
    my_workers = DynamicSupervisor.addWorker(message)

    Enum.each(1..5, fn(_x) ->
      Registry.register(MyRegistry, my_workers, keys: :unique)
    end)

    connections = Registry.lookup(MyRegistry)
    next_index = Scheduler.read_and_increment()

    {pid, _value = nil} = Enum.at(connections, rem(next_index, length(connections)))

    GenServer.cast(pid, {:worker, message})
    {:noreply, state}
  end
end