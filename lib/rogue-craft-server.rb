require_relative './rogue-craft-server/container_loader'


module RogueCraftServer
  def self.run
    container = ContainerLoader.load
    snapshot = container[:snapshot_stream]
    world = container[:world]

    EventMachine.run do
      EventMachine.start_server('127.0.0.1', ENV['PORT'].to_i, Server::Connection)

      EventMachine.add_periodic_timer(0.1) do
        EventMachine.defer { snapshot.stream }
      end

      EventMachine.add_periodic_timer(0.1) do
        EventMachine.defer { world.update }
      end
    end
  end
end
