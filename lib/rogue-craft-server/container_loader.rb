require 'dry-container'
require 'dry-auto_inject'
require 'ohm'
require 'ohm/contrib'
require 'ohm/validations'
require 'dotenv'
require 'bcrypt'
require 'resque'
require 'concurrent-ruby'
require 'perlin'

Dotenv.load

class Container < Dry::Container
  def register(name, val, opts = {}, &block)
    opts.merge!(memoize: true, call: true)
    super(name, val, **opts, &block)
  end

  def []=(name, val)
    register(name, val)
  end
end


Dependency = Dry::AutoInject(Container.new)


require 'rogue-craft-common'

require 'eventmachine'
require 'dry-events'

require 'mail'

require_relative './server/server'
require_relative './handler/handler'
require_relative './model/model'
require_relative './event/event'
require_relative './schema/schema'
require_relative './snapshot/snapshot'
require_relative './job/job'
require_relative './command/command'
require_relative './location/location'
require_relative './ecs/ecs'
require_relative './route_map'


class ContainerLoader
  def self.load
    c = Dependency.container
    c[:logger] = -> { logger }

    register_rpc(c)
    init_mailer

    c[:token_lifetime] = -> { 3600 }
    c[:event] = -> { Event::Publisher.new }
    c[:private_key] = -> { ENV['SERVER_PRIVATE_KEY'] }
    c[:cert_chain] = -> { ENV['SERVER_CERT_CHAIN'] }

    Resque.redis = ENV['REDIS_URL']
    Resque.logger = c[:logger]
    redic = Redic.new(ENV['REDIS_URL'])
    redic.call('INFO')

    Ohm.redis = redic

    c[:connection_map] = -> { Server::ConnectionMap.new }
    c[:snapshot_stream] = -> { Snapshot::Stream.new }
    c[:snapshot_factory] = -> { Snapshot::Factory.new }

    register_ecs(c)

    c[:event].subscribe_listeners

    c
  end

  def self.logger
    logger = Logger.new(ENV['LOG_FILE'])
    logger.level = Logger.const_get(ENV['LOG_LEVEL'].upcase)

    logger
  end

  def self.register_ecs(c)
    c[:ecs_systems] = lambda do
      [
        ECS::System::Movement.new
      ]
    end
    c[:world] = -> { ECS::World.new }
  end

  def self.register_rpc(c)
    c[:clock] = -> { Interpolation::Clock.new(Time.new) }
    c[:firewall] = -> { Server::FireWall.new([Handler::Auth], 60, 3600 )}
    c[:router] = -> { Server::Router.new(RouteMap.new.load, c[:logger], c[:firewall]) }
    c[:serializer] = -> { RPC::Serializer.new(c.resolve(:logger)) }
    c[:async_store] = -> { RPC::AsyncStore.new(ENV['SERVER_RESPONSE_TIMEOUT'], c[:logger]) }
    c[:auth_handler] = -> { Handler::Auth.new }
    c[:meta_handler] = -> { Handler::Meta.new }
    c[:snapshot_handler] = -> { Handler::Snapshot.new }
    load_command_executors(c)
    c[:command_handler] = -> { Handler::Command.new }
    c[:message_dispatcher] = -> { RPC::MessageDispatcher.new(c[:serializer], c[:async_store], nil) }
  end

  def self.load_command_executors(c)
    c[:command_executors] = lambda do
      {
        direction_change: Command::Executor::DirectionChange.new
      }
    end
  end

  def self.init_mailer
    options = {
      address: ENV['MAIL_SERVER'],
      port: ENV['MAIL_PORT'],
      user_name: ENV['MAIL_USER'],
      password: ENV['MAIL_PASSWORD'],
      enable_starttls_auto: true
    }

    Mail.defaults do
      delivery_method :smtp, options
    end
  end
end
