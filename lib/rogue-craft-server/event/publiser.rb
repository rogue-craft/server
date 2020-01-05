class Event::Publisher
  include Dry::Events::Publisher[:default]

  EVENTS = [
    :player_logout, :player_unbind
  ].freeze

  def subscribe_listeners
    EVENTS.each(&method(:register_event))

    subscribe(Event::Listener::PlayerDisconnection.new)

    RogueCraftCommon.register_common_listeners(self, Dependency.container)
  end
end
