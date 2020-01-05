class ECS::World

  include Dependency[:ecs_systems, :logger]

  def initialize(args)
    super
    @player_entities = Concurrent::Map.new
  end

  def add_player(player_id)
    @logger.debug("Player #{player_id} added to ECS::World")

    @player_entities.compute(player_id) { ECS::Entity.new }
  end

  def remove_player(player_id)
    @logger.debug("Player #{player_id} removed from ECS::World")

    @player_entities.delete(player_id)
  end

  def player(player_id)
    @player_entities[player_id]
  end

  def update
    @player_entities.each_value do |entity|
      @ecs_systems.each do |system|
        system.process(entity) if system.supports?(entity)
      end
    end
  end
end
