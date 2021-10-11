class Server::ConnectionMap

  include Dependency[:logger]

  def initialize(**args)
    super

    @map = Concurrent::Map.new
  end

  def attach(connection, player_id)
    if @map[connection] || @map.key(player_id)
      raise ArgumentError.new('Player id or the Connection already exists in the map')
    end

    @logger.debug("Player #{player_id} attached to the ConnectionMap")

    @map.put(connection, player_id)
  end

  def player_id_of(connection)
    @map.fetch(connection)
  end

  def remove_connection(connection)
    removed_id = @map.delete(connection)

    @logger.debug("Player #{removed_id} removed from the ConnectionMap")
  end

  def each(&block)
    @map.each(&block)
  end
end
