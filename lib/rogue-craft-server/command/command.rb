module Command end
module Command::Executor end

Dir[File.dirname(__FILE__) + "/**/*.rb"].each { |f| require f unless __FILE__ == f }
