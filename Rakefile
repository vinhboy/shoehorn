require 'bundler'  
require 'rake'
require 'rake/testtask'

Bundler::GemHelper.install_tasks

Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
end

begin
  gem 'ci_reporter'
  require 'ci/reporter/rake/test_unit'
rescue Gem::LoadError
#  puts "Could not find ci_reporter gem, ignoring"
end
