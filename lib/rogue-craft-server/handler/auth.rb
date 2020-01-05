class Handler::Auth < RPC::InjectedHandler

  ACTIVATION_CODE_LENGTH = 10

  include Dependency[:token_lifetime, :logger, :event]

  def registration(msg, _)
    salt = SecureRandom.hex(20)
    pw = BCrypt::Password.create(salt + msg[:password])

    player = Model::Player.create(
      nickname: msg[:nickname],
      email: msg[:email],
      password: pw,
      salt: salt,
      activation_code: SecureRandom.hex(ACTIVATION_CODE_LENGTH),
      token: nil
    )

    Resque.enqueue(Job::Email, :activation, player.email, {activation_code: player.activation_code})

    @logger.info("Player #{player.id} registered")

    new_msg(parent: msg)
  end

  def login(msg, _)
    unless player = Model::Player.with(:nickname, msg[:nickname])
      return wrong_credentials(msg)
    end

    return inactive_player(msg) unless player.activation_code.nil?

    password = BCrypt::Password.new(player.password)
    login_pw = player.salt + msg[:password]

    unless password == login_pw
      return wrong_credentials(msg)
    end

    if player.token.nil? || player.token_expired?
      player.token = SecureRandom.uuid
      player.token_expiration = Time.new + @token_lifetime
      player.save
    end

    @logger.debug("Player #{player.id} logged in")

    new_msg(parent: msg, params: {token: player.token})
  end

  def logout(msg, player)
    player.update(token: nil)
    @event.publish(:player_logout, {player: player, connection: msg.source})

    @logger.debug("Player #{player.id} logged out")

    new_msg(parent: msg)
  end

  def activation(msg, _)
    player = Model::Player.with(:activation_code, msg[:activation_code])

    return invalid_code(msg) unless player

    player.update(activation_code: nil)

    new_msg(parent: msg)
  end

  private
  def wrong_credentials(parent)
    violations = {'username/password': ['Wrong credentials']}

    new_msg(parent: parent, code: RPC::Code::ACCESS_DENIED, params: {violations: violations})
  end

  def inactive_player(parent)
    violations = {'username/password': ['Please activate your account']}

    new_msg(parent: parent, code: RPC::Code::ACCESS_DENIED, params: {violations: violations})
  end

  def invalid_code(parent)
    violations = {'activation_code': ['Invalid activation code']}

    new_msg(parent: parent, code: RPC::Code::ACCESS_DENIED, params: {violations: violations})
  end
end
