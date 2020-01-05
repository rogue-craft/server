class ECS::System::Movement

  def supports?(entity)
    entity.has_movement?
  end

  def process(entity)
    entity.movement.write do |component|

    end
  end
end
