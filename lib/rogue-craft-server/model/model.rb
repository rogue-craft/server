module Model end
module Model::Repository end

require_relative 'base'

Dir[File.dirname(__FILE__) + "/*.rb"].each { |f| require f unless __FILE__ == f }
