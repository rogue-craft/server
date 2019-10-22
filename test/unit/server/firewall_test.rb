require_relative '../test'


class FirewallTest < MiniTest::Test

  def test_no_token
    firewall = Server::FireWall.new([], 60, 1800)

    acces_denied? do
      firewall.identify(:handler, RPC::Message.from(params: {}))
    end
  end

  def test_no_user
    firewall = Server::FireWall.new([], 60, 1800)
    msg = RPC::Message.from(params: {token: 'test_token'})

    Model::Player.expects(:with).with(:token, msg[:token]).returns(nil)

    acces_denied? do
      firewall.identify(:handler, msg)
    end
  end

  def test_expired_token
    firewall = Server::FireWall.new([], 60, 1800)
    msg = RPC::Message.from(params: {token: 'expired_token_value'})

    model = Model::Player.new
    model.expects(:token_expiration).returns(Time.new('2019-01-10 21:02:11'))

    Model::Player.expects(:with).with(:token, msg[:token]).returns(model)

    acces_denied? do
      firewall.identify(:handler, msg)
    end
  end

  def test_whitelist
    firewall = Server::FireWall.new([Symbol], 60, 1800)
    msg = RPC::Message.from(params: {})

    player = firewall.identify(:handler, msg)

    assert_nil(player)
  end

  def test_prolonging_lifetime
    additional_lifetime = 1800
    expiration_interval = 60

    firewall = Server::FireWall.new([], expiration_interval, additional_lifetime)
    msg = RPC::Message.from(params: {token: 'expired_token_value'})

    expiration = Time.new + expiration_interval

    model = Model::Player.new
    model.expects(:token_expiration).returns(expiration)
    model.expects(:token_expiration=).with(expiration + additional_lifetime)
    model.expects(:save)

    Model::Player.expects(:with).with(:token, msg[:token]).returns(model)

    assert_equal(model, firewall.identify(:handler, msg))
  end

  private
  def acces_denied?(&block)
    assert_raises(Server::FireWall::AccesDenied, &block)
  end
end
