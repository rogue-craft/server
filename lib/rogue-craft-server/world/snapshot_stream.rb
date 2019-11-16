class World::SnapshotStream < RPC::InjectedHandler

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
    @connection_map.each do |player_id, conn|
      send_msg(
        conn: conn,
        target: 'world/snapshot',
        params: @snapshot_factory.create(player_id)
      )
    end
  end
end
