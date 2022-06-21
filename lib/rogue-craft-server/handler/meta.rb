class Handler::Meta < RPC::InjectedHandler

  include Dependency[:clock]

  def ping(msg, _)
    new_msg(parent: msg, params: {time: @clock.now})
  end
end
