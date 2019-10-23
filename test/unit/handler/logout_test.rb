
require_relative '../test'


class LogoutTest < MiniTest::Test

  def test_happy_path
    msg = RPC::Message.from(params: {token: 'token'})

    player = mock
    player.expects(:update).with(token: nil)

    handler = Handler::Auth.new
    response = handler.logout(msg, player)

    assert_equal(RPC::Code::OK, response.code)
    assert_equal(msg.id, response.parent)
  end
end
