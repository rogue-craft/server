class Snapshot::Factory

  def create(player_id)
    # @type [Model::Player]
    player = Model::Player[player_id]
    movement = player.movement

    {
      snapshot: {
        player: {
          x: movement.hitbox_x,
          y: movement.hitbox_y,
          type: :player,
          movement: {
            direction: Interpolation::Direction::SOUTH,
            speed: movement.speed
          }
        },
        entities: [
          {
            x: 100,
            y: 100,
            type: :tree
          }
        ],
        timestamp: Time.now_ms - 2000
      }
    }
  end
end
