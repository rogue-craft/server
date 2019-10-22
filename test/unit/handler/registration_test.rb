require_relative '../test'


class RegistrationTest < MiniTest::Test

  def test_registration
    msg_params = {
      nickname: 'TestPlayer',
      password: 'some-pw',
      email: 'test@email.com'
    }
    msg = RPC::Message.from(params: msg_params)

    created_player = OpenStruct.new(id: 10)

    Model::Player.expects(:create).with do |params|
      assert_equal(msg_params[:nickname], params[:nickname])
      assert_equal(msg_params[:email], params[:email])
      assert(params[:activation_code].is_a?(String) && 20 == params[:activation_code].length)
      assert_nil(params[:token])

      assert(BCrypt::Password.new(params[:password]) == params[:salt] + msg_params[:password])
    end
      .returns(created_player)

    logger = mock
    logger.expects(:info).with("Player #{10} registered")
    handler = Handler::Auth.new(logger: logger)

    handler.registration(msg, nil)
  end
end
