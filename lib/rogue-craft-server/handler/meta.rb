class Handler::Meta < RPC::InjectedHandler
  def validate_token(msg, _)
    new_msg(parent: msg)
  end
end
