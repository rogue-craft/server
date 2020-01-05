require_relative '../test'


class LoginTest < MiniTest::Test

  def test_not_found
    msg = RPC::Message.from(params: {nickname: 'Player1'})

    Model::Player.expects(:with).with(:nickname, msg[:nickname]).returns(nil)

    handler = new_handler
    response = handler.login(msg, nil)

    assert_equal(RPC::Code::ACCESS_DENIED, response.code)
    assert_equal(msg.id, response.parent)
  end

  def test_inactive_player
    msg = RPC::Message.from(params: {nickname: 'Player101', password: 'pw01'})
    player = OpenStruct.new(activation_code: 'activation code', salt: 'salt', password: BCrypt::Password.create('something-else').to_s)

    Model::Player.expects(:with).with(:nickname, msg[:nickname]).returns(player)

    handler = new_handler
    response = handler.login(msg, nil)

    assert_equal(RPC::Code::ACCESS_DENIED, response.code)
    assert_equal(['Please activate your account'], response[:violations][:'username/password'])
    assert_equal(msg.id, response.parent)
  end

  def test_wrong_password
    msg = RPC::Message.from(params: {nickname: 'Player101', password: 'pw01'})
    player = OpenStruct.new(activation_code: nil, salt: 'salt', password: BCrypt::Password.create('something-else').to_s)

    Model::Player.expects(:with).with(:nickname, msg[:nickname]).returns(player)

    handler = new_handler
    response = handler.login(msg, nil)

    assert_equal(RPC::Code::ACCESS_DENIED, response.code)
    assert_equal(['Wrong credentials'], response[:violations][:'username/password'])
    assert_equal(msg.id, response.parent)
  end

  def test_happy_path
    msg = RPC::Message.from(params: {nickname: 'Player101', password: 'pw01'})

    SecureRandom.expects(:uuid).at_least_once.returns('new-token')
    Time.expects(:new).returns(10)

    player = mock
    player.expects(:id).returns(123)
    player.expects(:activation_code).returns(nil)
    player.expects(:salt).returns('salt')
    player.expects(:password).returns(BCrypt::Password.create('saltpw01'))
    player.expects(:token).twice.returns('expired-token').then.returns('new-token')
    player.expects(:token_expired?).returns(true)

    player.expects(:token=).with('new-token')
    player.expects(:token_expiration=).with(110)
    player.expects(:save).with

    Model::Player.expects(:with).with(:nickname, msg[:nickname]).returns(player)

    handler = new_handler(token_lifetime: 100)
    response = handler.login(msg, nil)

    assert_equal(RPC::Code::OK, response.code)
    assert_equal(msg.id, response.parent)
  end

  private
  def new_handler(token_lifetime: nil)
    Handler::Auth.new(token_lifetime: token_lifetime, logger: Logger.new(IO::NULL))
  end
end
