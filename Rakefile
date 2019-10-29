require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.test_files = Dir.glob("#{__dir__}/test/*_test.rb")
  t.warning = false
  t.verbose = true
end

task :default => :test


