class RouteMap

  FORMAT_USERNAME = /^[A-Za-z0-9]+(?:[ _-][A-Za-z0-9]+)*$/.freeze
  FORMAT_PW = /^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[\W]).{8,}$/.freeze
  FORMAT_EMAIL = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.freeze

  PW_MIN = 5
  PW_MAX = 30

  USERNAME_PARAMS = {min_size?: 5, max_size?: 15, format?: FORMAT_USERNAME}
  PW_PARAMS = {min_size?: 5, max_size?: 30, format?: FORMAT_PW}

  include Dependency[:auth_handler, :meta_handler, :snapshot_handler, :command_handler]

  def load
    {
      auth: {
        handler: @auth_handler,
        schema: {
          login: Schema::Auth::Login.new,
          registration: Schema::Auth::Registration.new,
          activation: Schema::Auth::Acivation.new,
          logout: Schema::Auth::Logout.new
        }
      },
      snapshot: {
        handler: @snapshot_handler,
        schema: {
          start: Schema::Snapshot::Start.new
        }
      },
      command: {
        handler: @command_handler,
        schema: {
          execute: Schema::Command::Execute.new
        }
      },
      meta: {
        handler: @meta_handler,
        schema: {
          ping: Schema::Meta::Ping.new
        }
      }
    }
  end
end
