class Handler::Snapshot < RPC::InjectedHandler

  include Dependency[:connection_map, :world]

  def start(msg, ctx)
    player = ctx[:player]

    entity = @world.add_player(player.id)
    entity.add(ECS::Component::Movement.new(nil))

    @connection_map.attach(msg.source, player.id)

    new_msg(parent: msg)
  end
end
