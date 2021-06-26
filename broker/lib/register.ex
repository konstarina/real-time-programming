defmodule Register do
  use Agent
  require Logger

  def init() do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def get(key) do
    result =Agent.get(__MODULE__, fn registry -> Map.get(registry, key, []) end)
    Logger.info("[PubSub] get topic by #{key}")
    result
  end

  def add(key, values) do
    Logger.info("[PubSub] add sub to topic #{key}")
    Agent.update(__MODULE__, fn registry -> Map.put(registry, key, [values | Map.get(registry, key, [])]) end)
  end
end
