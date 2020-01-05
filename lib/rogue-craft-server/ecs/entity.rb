class ECS::Entity

  def initialize
    @components = Concurrent::Map.new
  end

  def add(component)
    if has?(component.class)
      raise ArgumentError.new("Component #{component.class} is already set")
    end

    @components.put_if_absent(component.class, component)
  end

  def get(klass)
    @components.fetch(klass)
  end

  def movement
    @components.fetch(ECS::Component::Movement)
  end

  def has_movement?
    has?(ECS::Component::Movement)
  end

  def remove(klass)
    @components.delete(klass)
  end

  def has?(klass)
    nil != @components[klass]
  end
end
