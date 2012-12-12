module Einhorn::Event
  class Stream

    @@subscriptions = {}

    def self.subscribe!(name, conn)
      @@subscriptions[name] ||= []
      @@subscriptions[name] << conn
    end

    def self.unsubscribe!(name, conn)
      @@subscriptions[name].delete conn
      @@subscriptions.delete name if @@subscriptions[name].length == 0
    end

    def self.subscriptions(conn)
      @@subscriptions.select do |name, conns|
        conns.include?(conn)
      end
    end

    def self.publish(name, message)
      if @@subscriptions[name]
        @@subscriptions[name].each do |conn|
          Einhorn::Client::Transport.send_message(conn, response)
        end
      end
    end
  end
end
