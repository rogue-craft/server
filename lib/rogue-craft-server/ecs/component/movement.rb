class ECS::Component::Movement < ECS::Component::Base

  attr_reader :model

  def initialize(model)
    super()
    @model = model
  end
end
