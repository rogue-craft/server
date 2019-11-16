class Server::Connection < EventMachine::Connection

  include Dependency[:event, :private_key, :cert_chain, :snapshot_stream]

  def post_init
    start_tls(private_key_file: @private_key, cert_chain_file: @cert_chain)
  end

  def ssl_handshake_completed
    p "Hello"

    port, ip = Socket.unpack_sockaddr_in(get_peername)

    p port, ip
  end

  def unbind
    p "unbind"

    @snapshot_stream.detach_connection(self)

    super
  end

  def receive_data(raw)
    @event.publish(:receive_data, {raw: raw, connection: self})
  end
end
