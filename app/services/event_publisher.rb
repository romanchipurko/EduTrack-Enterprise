require "bunny"
require "json"

class EventPublisher
  def self.publish(routing_key:, payload:)
    connection = Bunny.new(ENV.fetch("RABBITMQ_URL"))
    connection.start

    channel = connection.create_channel
    exchange = channel.topic("edutrack.events", durable: true)

    exchange.publish(
      payload.to_json,
      routing_key: routing_key,
      content_type: "application/json",
      timestamp: Time.current.to_i
    )
  ensure
    connection&.close
  end
end
