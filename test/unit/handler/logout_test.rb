require_relative '../test'


class LogoutTest < MiniTest::Test

  def test_happy_path
    msg = RPC::Message.from(params: {token: 'token'}, source: :source)

    sequence = sequence('logout')

    player = mock
    player.expects(:update).with(token: nil).in_sequence(sequence)
    player.expects(:id).returns(123)

    event = mock
    event.expects(:publish).with(:player_logout, {player: player, connection: :source}).in_sequence(sequence)

    handler = Handler::Auth.new(event: event, logger: Logger.new(IO::NULL))
    response = handler.logout(msg, player)

    assert_equal(RPC::Code::OK, response.code)
    assert_equal(msg.id, response.parent)
  end
end
