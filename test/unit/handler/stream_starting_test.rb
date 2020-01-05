require_relative '../test'

class StreamStartingTest < MiniTest::Test

  def test_happy_path
    conn = mock

    msg = RPC::Message.from(source: conn)

    player = mock
    player.expects(:id).times(2).returns(101)

    entity = ECS::Entity.new
    assert(false == entity.has?(ECS::Component::Movement))

    seq = sequence(:add_to_world)

    world = mock
    world.expects(:add_player).with(101).returns(entity).in_sequence(seq)

    map = mock
    map.expects(:attach).with(conn, 101).in_sequence(seq)

    handler = Handler::Snapshot.new(connection_map: map, world: world)
    response = handler.start(msg, {player: player})

    assert_equal(RPC::Code::OK, response.code)


    assert(entity.has?(ECS::Component::Movement))
  end
end
