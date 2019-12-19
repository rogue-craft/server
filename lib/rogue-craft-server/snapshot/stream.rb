class Snapshot::Stream < RPC::InjectedHandler

  include Dependency[:snapshot_factory, :logger]

  def initialize(*args)
    super
    @connection_map = Concurrent::Hash.new
  end

  def attach(player_id, conn)
    @logger.debug("Player #{player_id} attached to the SnapshotStream")

    @connection_map[player_id] = conn
  end

  def detach_player(player_id)
    @logger.debug("Player #{player_id} detached from the SnapshotStream")

    @connection_map.delete(player_id)
  end

  def detach_connection(removed)
    @connection_map.delete_if do |player_id, conn|
      matches = conn == removed

      if matches
        @logger.debug("Player #{player_id} detached from the SnapshotStream by its matching connection")
      end

      matches
    end
  end

  def stream
    @connection_map.each do |player_id, conn|
      @logger.debug("Sending Snapshot to #{player_id}")

      send_msg(
        conn: conn,
        target: 'snapshot/stream',
        params: @snapshot_factory.create(player_id)
      )
    end
  end
end
