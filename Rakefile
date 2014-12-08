require 'rspec/core/rake_task'
require 'bundler/gem_tasks'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

namespace :restspec do
  task :run_example_app do
    Dir.chdir("examples/store-api") do
      exec("BUNDLE_GEMFILE=Gemfile bundle exec rails s -p 3000")
    end
  end

  task :run_example_tests do
    Dir.chdir("examples/store-api-tests") do
      exec("BUNDLE_GEMFILE=Gemfile bundle exec rspec spec/")
    end
  end
end
