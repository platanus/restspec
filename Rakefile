require 'rspec/core/rake_task'
require 'bundler/gem_tasks'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

desc "generate rdoc"
task :rdoc do
  sh "bundle exec yardoc"
end

namespace :restspec do
  desc 'Run the example application defined in examples/store-api'
  task :run_example_app do
    Dir.chdir("examples/store-api") do
      exec("BUNDLE_GEMFILE=Gemfile bundle exec rails s -p 3000")
    end
  end

  desc 'Run the example application tests defined in examples/store-api-tests'
  task :run_example_tests do
    Dir.chdir("examples/store-api-tests") do
      exec("BUNDLE_GEMFILE=Gemfile bundle exec rspec spec/")
    end
  end
end
