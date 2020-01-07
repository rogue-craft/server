class Event::Listener::PlayerDisconnection

  include Dependency[:connection_map, :world, :logger]

  def on_player_unbind(event)
    remove(event[:connection])
  end

  def on_player_logout(event)
    connection = event[:connection]

    remove(connection)

    connection.close_by_server
  end

  private
  def remove(connection)
    player_id = nil

    begin
      player_id = @connection_map.player_id_of(connection)
    rescue KeyError
      @logger.info('No Player id found for connection')
    end

    if player_id
      @world.remove_player(player_id)
    end

    @connection_map.remove_connection(connection)
  end
end
