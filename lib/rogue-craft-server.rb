require_relative './rogue-craft-server/container_loader'


module RogueCraftServer
  def self.run
    container = ContainerLoader.load
    snapshot = container[:snapshot_stream]
    world = container[:world]
    logger = container[:logger]

    EventMachine.run do
      EventMachine.start_server(ENV['SERVER_HOST'], ENV['SERVER_PORT'].to_i, Server::Connection, container[:event], container[:private_key], container[:cert_chain])

      EventMachine.add_periodic_timer(0.1) do
        EventMachine.defer { snapshot.stream }
      end

      EventMachine.add_periodic_timer(0.1) do
        EventMachine.defer { world.update }
      end
    end
  end
end
