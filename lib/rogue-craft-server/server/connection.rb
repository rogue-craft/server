class Server::Connection < EventMachine::Connection

  include Dependency[:event, :private_key, :cert_chain, :snapshot_stream]

  def post_init
    start_tls(private_key_file: @private_key, cert_chain_file: @cert_chain)
  end

  def ssl_handshake_completed
    p "Hello"

    p address
  end

  def address
    Socket.unpack_sockaddr_in(get_peername)
  end

  def unbind
    p "unbind"

    unless @closed_by_server
      @event.publish(:player_unbind, {connection: self})
    end

    super
  end

  def close_by_server
    p "closed by server"

    @closed_by_server = true

    close_connection
  end

  def receive_data(raw)
    @event.publish(:receive_data, {raw: raw, connection: self})
  end
end
