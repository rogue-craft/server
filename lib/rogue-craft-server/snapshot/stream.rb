class Snapshot::Stream < RPC::InjectedHandler

  include Dependency[:connection_map, :snapshot_factory]

  def stream
    @connection_map.each do |conn, player_id|
      send_msg(
        conn: conn,
        target: 'snapshot/stream',
        params: @snapshot_factory.create(player_id)
      )
    end
  end
end
