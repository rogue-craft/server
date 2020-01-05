class Event::Listener::PlayerDisconnection

  include Dependency[:connection_map, :world]

  def on_player_unbind(event)
    connection = event[:connection]

    @world.remove_player(@connection_map.play_id_of(connection))
    @connection_map.remove_connection(connection)
  end

  def on_player_logout(event)
    connection = event[:connection]

    @world.remove_player(@connection_map.play_id_of(connection))
    @connection_map.remove_connection(connection)

    connection.close_by_server
  end
end
