require "bundler/gem_tasks"
require "rake/testtask"

namespace :test do
  Rake::TestTask.new(:unit) do |t|
    t.libs << "test"
    t.test_files = FileList['test/unit/test*.rb']
  end

  Rake::TestTask.new(:acceptance) do |t|
    t.libs << "test"
    t.test_files = FileList['test/acceptance/test*.rb']
  end
end

task :test => ["test:unit", "test:acceptance"]

task :default => :test

