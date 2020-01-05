class Command::Executor::DirectionChange

  include Dependency[:world]

  def call(command, player)
    @world.player(player.id).movement.write do |component|
      component.model.update(direction: command[:direction])
    end
  end
end
