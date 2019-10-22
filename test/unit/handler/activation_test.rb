require_relative '../test'


class ActivationTest < MiniTest::Test

  def test_invalid_code
    msg = RPC::Message.from(params: {activation_code: 'invalid-code'})

    Model::Player.expects(:with)
      .with(:activation_code, msg[:activation_code])
      .returns(nil)

    handler = Handler::Auth.new
    response = handler.activation(msg, nil)

    assert_equal(RPC::Code::ACCESS_DENIED, response.code)
    assert_equal(['Invalid activation code'], response[:violations][:activation_code])
    assert_equal(msg.id, response.parent)
  end

  def test_happy_path
    msg = RPC::Message.from(params: {activation_code: 'code'})

    player = mock
    player.expects(:update).with(activation_code: nil)

    Model::Player.expects(:with)
      .with(:activation_code, msg[:activation_code])
      .returns(player)

    handler = Handler::Auth.new
    response = handler.activation(msg, nil)

    assert_equal(RPC::Code::OK, response.code)
    assert_equal(msg.id, response.parent)
  end
end

