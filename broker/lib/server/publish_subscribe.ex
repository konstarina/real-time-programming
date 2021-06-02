defmodule PublishSubscribe do

  def parse(line) do
    case String.split(line, " ", parts: 3) |> Enum.map(fn string -> String.trim(string) end) do
      ["Publish", topic, data] -> {:ok, {:publish, topic, data}}
      ["Subscribe", topic] -> {:ok, {:subscribe, topic}}
      _ -> {:error, :unknown_command}
    end
  end

  def run(command, socket)

  def run({:publish, topic, data}, socket) do
    all_subscribers = MyRegistry.get_by_topic(topic)

    Enum.each(all_subscribers, fn subscriber -> Server.write_line(subscriber.subscriber, {:for_subscriber, data}) end)
    {:ok, "The message from TCP server \r\n"}
  end

  def run({:subscribe, topic}, socket) do
    MyRegistry.add_subscriber(topic, socket)

    {:ok, "The message from TCP Client\r\n"}
  end
end
