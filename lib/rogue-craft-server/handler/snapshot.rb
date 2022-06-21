class Handler::Snapshot < RPC::InjectedHandler

  include Dependency[:connection_map, :world]

  def start(msg, ctx)
    # @type [Model::Player]
    player = ctx[:player]
    # @type [ECS::Entity]
    entity = @world.add_player(player.id)
    entity.add(ECS::Component::Movement.new(movement_of(player)))

    @connection_map.attach(msg.source, player.id)

    new_msg(parent: msg)
  end

  private
  # @param player [Model::Player]
  #
  def movement_of(player)
    movement = player.movement

    unless movement
      movement = Model::Movement.new
      movement.x = 0
      movement.y = 0
      movement.hitbox_x = 0
      movement.hitbox_y = 0
      movement.speed = 0.01
      movement.save

      player.update(movement: movement)
    end

    movement
  end
end
