class Snapshot::Factory

  def create(player_id)
    {
      player: {
        x: 100,
        y: 87,
        type: :player
      },
      entities: [
        {
          x: 100,
          y: 88,
          type: :tree
        }
      ],
      timestamp: Time.now.to_f * 1000
    }
  end
end
