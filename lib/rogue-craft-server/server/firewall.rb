class Server::FireWall

  def initialize(whitelisted_handlers, expiration_interval, additional_lifetime)
    @whitelisted_handlers = whitelisted_handlers
    @expiration_interval = expiration_interval
    @additional_lifetime = additional_lifetime
  end

  class AccesDenied < Exception
  end

  def identify(handler, msg)
    return nil if @whitelisted_handlers.include?(handler.class)

    player = Model::Player.with(:token, token_of(msg))

    unless player
      raise AccesDenied.new('Unknown :token') unless player
    end

    expiration = player.token_expiration

    if expiration <= Time.new
      raise AccesDenied.new(':token expired')
    end

    prolong_lifetime(expiration, player)

    player
  end

  private
  def token_of(msg)
    unless token = msg[:token]
      raise AccesDenied.new('Missing :token')
    end
    token
  end

  def prolong_lifetime(expiration, player)
    if (expiration - Time.new) <= @expiration_interval
      player.token_expiration = expiration + @additional_lifetime
      player.save
    end
  end
end
