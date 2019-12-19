class Handler::Snapshot < RPC::InjectedHandler

  include Dependency[:snapshot_stream]

  def start(msg, ctx)
    @snapshot_stream.attach(ctx[:player].id, msg.source)

    new_msg(parent: msg)
  end
end
