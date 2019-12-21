class Snapshot::Factory

  def create(player_id)
    {
      player: {
        x: 100,
        y: 100,
        type: :player,
        movement: {
          direction: Interpolation::Direction::SOUTH,
          speed: 0.001
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
  end
end
