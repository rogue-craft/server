class Server::Router < RPC::Router

  def initialize(route_map, logger, firewall)
    super(route_map, logger)
    @firewall = firewall
  end

  def call_handler(handler, action, message)
    begin
        player = @firewall.identify(handler, message)
    rescue Server::FireWall::AccesDenied
        return RPC::Message.from(code: RPC::Code::ACCESS_DENIED)
    end

    ctx = {player: player}
    handler.send(action, message, ctx)
  end
end
