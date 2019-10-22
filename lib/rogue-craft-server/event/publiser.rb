class Event::Publisher
  include Dry::Events::Publisher[:default]

  def initialize
    super
    subscribe_listeners
  end

  private
  def subscribe_listeners
    RogueCraftCommon.register_common_listeners(self, Dependency.container)
  end
end
