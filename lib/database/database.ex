defmodule Database do


use GenServer

  def start_link(string) do
    GenServer.start_link(__MODULE__, string, %{time: :os.system_time(:millisecond)}, name: __MODULE__)
  end

  def init(_msg) do
    list = []
    {:ok, list}
  end

  defp insert_to_db(string, collection) do
    {:ok, pid} = Mongo.start_link(url: "mongodb://localhost:27017/tweets_processed")
    Mongo.insert_one!(pid, collection, string)
  end
 #adaptive batching with a batch size 128
 
  @impl true
  def handle_cast({:data, item}, list, state) do
    window = :os.system_time(:millisecond)
    add_to_db = [item | list]
    if Enum.count(add_to_db) >= 128  or window - state.time > 200 do
      GenServer.cast(__MODULE__, :batch)
    end

    {:noreply, add_to_db, %{time: :os.system_time(:millisecond)}}
  end

  @impl true
  def handle_cast(:batch, list, state) do
    spawn(fn ->
      Enum.each(list, fn item ->
        if Map.equal?(Map.take(item, ["protected"]),%{"protected" => false}) do
          insert_to_db(item, "Users")
        else
          insert_to_db(item, "Tweets")
        end
      end)
    end)
    {:noreply, [], %{time: state.time}}
  end
end
