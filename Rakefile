require "rake/testtask"
require 'resque/tasks'
require_relative 'lib/rogue-craft-server/container_loader'


task :load do
  ContainerLoader.load
end

task 'resque:work' => [:load]

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/*_test.rb"]
end

task :default => :test

