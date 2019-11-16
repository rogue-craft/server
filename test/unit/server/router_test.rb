require_relative '../test'

class RouterTest < MiniTest::Test

  class TestHandler
    def login(message, player)
      RPC::Message.from(code: RPC::Code::OK)
    end
  end

  def test_happy_path
    message = RPC::Message.new('id', 'auth/login', nil, {email: 'hello@example.com'}, RPC::Code::OK, nil)

    handler = TestHandler.new

    firewall = mock
    firewall.expects(:identify).with(handler, message).returns(:player)

    router = new_router(handler, firewall)

    res = router.dispatch(message)

    assert(res.is_a?(RPC::Message))
    assert_equal(RPC::Code::OK, res.code)
  end

  def test_access_denied
    message = RPC::Message.new('id', 'auth/login', nil, {email: 'hello@example.com'}, RPC::Code::OK, nil)

    handler = mock

    firewall = mock
    firewall.expects(:identify).with(handler, message).raises(Server::FireWall::AccesDenied.new)

    router = new_router(handler, firewall)

    res = router.dispatch(message)

    assert(res.is_a?(RPC::Message))
    assert_equal(RPC::Code::ACCESS_DENIED, res.code)
    assert_equal(message.id, res.parent)
  end

  class TestLoginSchema < Dry::Validation::Contract
    params do
      required(:email).filled
    end
  end

  private
  def new_router(handler, firewall, logger = nil)
    map = {
      auth: {handler: handler, schema: {
        login: TestLoginSchema.new
      }}
    }
    logger = logger ? logger : mock

    Server::Router.new(map, logger, firewall)
  end
end
