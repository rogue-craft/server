class Handler::Meta < RPC::InjectedHandler

  def ping(msg, _)
    new_msg(parent: msg)
  end
end
