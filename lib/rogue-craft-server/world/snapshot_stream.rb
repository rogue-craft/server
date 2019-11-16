class World::SnapshotStream

  include Dependency[:snapshot_factory]

  def initialize(*args)
    super
    @connection_map = Concurrent::Hash.new
  end

  def attach(player_id, conn)
    @connection_map[player_id] = conn
  end

  def detach_player(player_id)
    @connection_map.delete(player_id)
  end

  def detach_connection(removed)
    @connection_map.delete_if {|_, conn| conn == removed }
  end

  def stream
    @connection_map.each do |id, conn|
      @snapshot_factory.create(id)

      # send message
    end
  end
end
