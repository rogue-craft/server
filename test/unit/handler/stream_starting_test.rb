require_relative '../test'

class StreamStartingTest < MiniTest::Test

  def test_happy_path
    msg = RPC::Message.from(source: :conn)

    player = mock
    player.expects(:id).returns(101)

    stream = mock
    stream.expects(:attach).with(101, :conn)

    handler = Handler::Snapshot.new(snapshot_stream: stream)
    response = handler.start(msg, {player: player})

    assert_equal(RPC::Code::OK, response.code)
  end
end
