class Handler::World < RPC::InjectedHandler

  include Dependency[:snapshot_stream]

  def start_stream(msg, player)
    @snapshot_stream.attach(player.id, msg.source)
  end
end
