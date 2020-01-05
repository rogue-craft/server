require_relative '../../test'

class PlayerDisconnectionTest < MiniTest::Test

  def test_unbind
    connection = mock
    event = {connection: connection}

    seq = sequence(:unbind)

    map = mock
    map.expects(:play_id_of).with(connection).returns(101).in_sequence(seq)

    world = mock
    world.expects(:remove_player).with(101).in_sequence(seq)

    map.expects(:remove_connection).with(connection).in_sequence(seq)

    listener = Event::Listener::PlayerDisconnection.new(connection_map: map, world: world)
    listener.on_player_unbind(event)
  end

  def test_logout
    sequence = sequence('logout')

    connection = mock
    event = {connection: connection}

    map = mock
    map.expects(:play_id_of).with(connection).returns(66).in_sequence(sequence)

    world = mock
    world.expects(:remove_player).with(66).in_sequence(sequence)

    map.expects(:remove_connection).with(connection).in_sequence(sequence)

    connection.expects(:close_by_server).in_sequence(sequence)

    listener = Event::Listener::PlayerDisconnection.new(connection_map: map, world: world)
    listener.on_player_logout(event)
  end
end
