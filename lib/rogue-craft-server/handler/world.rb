class Handler::World < RPC::InjectedHandler

  include Dependency[:snapshot_stream]

  def start_stream(msg, ctx)
    @snapshot_stream.attach(ctx[:player].id, msg.source)

    new_msg(parent: msg)
  end
end
