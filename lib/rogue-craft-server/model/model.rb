module Model end

require_relative 'base_model'

Dir[File.dirname(__FILE__) + "/*.rb"].each { |f| require f unless __FILE__ == f }
