# Defines our constants
RACK_ENV = ENV['RACK_ENV'] ||= 'development' unless defined?(RACK_ENV)
PADRINO_ROOT = File.expand_path('../..', __FILE__) unless defined?(PADRINO_ROOT)

# Load our dependencies
require 'bundler/setup'
Bundler.require(:default, RACK_ENV)

require_relative '../../lib/rogue-craft-server/model/model.rb'

require 'dotenv'
require 'logger'

Dotenv.load

##
# ## Enable devel logging
#
# Padrino::Logger::Config[:development][:log_level]  = :devel
# Padrino::Logger::Config[:development][:log_static] = true
#
# ## Configure Ruby to allow requiring features from your lib folder
#
# $LOAD_PATH.unshift Padrino.root('lib')
#
# ## Enable logging of source location
#
# Padrino::Logger::Config[:development][:source_location] = true
#
# ## Configure your I18n
#
# I18n.default_locale = :en
# I18n.enforce_available_locales = false
#
# ## Configure your HTML5 data helpers
#
# Padrino::Helpers::TagHelpers::DATA_ATTRIBUTES.push(:dialog)
# text_field :foo, :dialog => true
# Generates: <input type="text" data-dialog="true" name="foo" />
#
# ## Add helpers to mailer
#
# Mail::Message.class_eval do
#   include Padrino::Helpers::NumberHelpers
#   include Padrino::Helpers::TranslationHelpers
# end

##
# Require initializers before all other dependencies.
# Dependencies from 'config' folder are NOT re-required on reload.
#
Padrino.dependency_paths.unshift Padrino.root('config/initializers/*.rb')

logger = Logger.new(ENV['LOG_FILE'])
logger.extend(Padrino::Logger::Extensions)
logger.level = Logger.const_get(ENV['LOG_LEVEL'].upcase)

Padrino.logger = logger

##
# Add your before (RE)load hooks here
# These hooks are run before any dependencies are required.
#
Padrino.before_load do
end

##
# Add your after (RE)load hooks here
#
Padrino.after_load do
end

Padrino.load!
