class Command::Executor::DirectionChange

  include Dependency[:world]

  # @param player [Model::Player]
  #
  def call(command, player)
    @world.player(player.id).movement.write do |component|
      # @type [Model::Movement]
      movement = component.model

      x, y, hitbox_x, hitbox_y = Interpolation.position(
        movement.x, movement.y, movement.speed, command[:direction], movement.updated_at
      )

      hitbox_x = movement.hitbox_x if hitbox_x.nil?
      hitbox_y = movement.hitbox_y if hitbox_y.nil?

      p x, y, hitbox_x, hitbox_y

      movement.update(x: x, y: y, hitbox_x: hitbox_x, hitbox_y: hitbox_y)
    end
  end
end
