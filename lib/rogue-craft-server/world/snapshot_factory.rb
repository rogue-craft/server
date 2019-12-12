class World::SnapshotFactory

  def create(player_id)
    {
      player: {
        x: 100,
        y: 87
      },
      entities: [
      ],
      timestamp: Time.now.to_f * 1000
    }
  end
end
