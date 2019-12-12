require_relative './rogue-craft-server/container_loader'


module RogueCraftServer
  def self.run
    container = ContainerLoader.load
    snapshot = container[:snapshot_stream]

    EventMachine.run do
      EventMachine.add_periodic_timer(0.1) { snapshot.stream }
      EventMachine.start_server('127.0.0.1', ENV['PORT'].to_i, Server::Connection)
    end
  end
end
