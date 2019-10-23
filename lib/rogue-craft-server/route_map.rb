class RouteMap

  FORMAT_USERNAME = /^[A-Za-z0-9]+(?:[ _-][A-Za-z0-9]+)*$/.freeze
  FORMAT_PW = /^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[\W]).{8,}$/.freeze
  FORMAT_EMAIL = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.freeze

  PW_MIN = 5
  PW_MAX = 30

  USERNAME_PARAMS = {min_size?: 5, max_size?: 15, format?: FORMAT_USERNAME}
  PW_PARAMS = {min_size?: 5, max_size?: 30, format?: FORMAT_PW}

  include Dependency[:auth_handler]

  def load
    {
      auth: {
        handler: @auth_handler,
        schema: {
          login: Schema::Login.new,
          registration: Schema::Registration.new,
          activation: Schema::Acivation.new,
          logout: Schema::Logout.new
        }
      }
    }
  end
end
