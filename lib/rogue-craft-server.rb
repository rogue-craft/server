require_relative './rogue-craft-server/container_loader'

ContainerLoader.load


module RogueCraftServer
  def self.run
    Resque.enqueue(Job::Email)

    EventMachine.run do
      EventMachine.start_server('127.0.0.1', ENV['PORT'].to_i, Server::Connection)
    end
  end
end
