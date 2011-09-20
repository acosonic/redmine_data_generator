#!/usr/bin/env ruby
require 'redmine_plugin_support'

Dir[File.expand_path(File.dirname(__FILE__)) + "/lib/tasks/**/*.rake"].sort.each { |ext| load ext }

RedminePluginSupport::Base.setup do |plugin|
  plugin.project_name = 'redmine_data_generator'
  plugin.default_task = [:test]
  plugin.tasks = [:doc, :release, :clean] # no spec, cucumber
end


# Testing taked from Rails
require 'rake/testtask'

desc 'Run all unit, functional and integration tests'
task :test do
  errors = %w(test:units test:functionals test:integration).collect do |task|
    begin
      Rake::Task[task].invoke
      nil
    rescue => e
      task
    end
  end.compact
  abort "Errors running #{errors.to_sentence}!" if errors.any?
end

namespace :test do
  Rake::TestTask.new(:units => :environment) do |t|
    t.libs << "test"
    t.pattern = 'test/unit/**/*_test.rb'
    t.verbose = true
  end
  Rake::Task['test:units'].comment = "Run the unit tests in test/unit"

  Rake::TestTask.new(:functionals => :environment) do |t|
    t.libs << "test"
    t.pattern = 'test/functional/**/*_test.rb'
    t.verbose = true
  end
  Rake::Task['test:functionals'].comment = "Run the functional tests in test/functional"

  Rake::TestTask.new(:integration => :environment) do |t|
    t.libs << "test"
    t.pattern = 'test/integration/**/*_test.rb'
    t.verbose = true
  end
  Rake::Task['test:integration'].comment = "Run the integration tests in test/integration"

  Rake::TestTask.new(:benchmark => :environment) do |t|
    t.libs << 'test'
    t.pattern = 'test/performance/**/*_test.rb'
    t.verbose = true
    t.options = '-- --benchmark'
  end
  Rake::Task['test:benchmark'].comment = 'Benchmark the performance tests'

  Rake::TestTask.new(:profile => :environment) do |t|
    t.libs << 'test'
    t.pattern = 'test/performance/**/*_test.rb'
    t.verbose = true
  end
  Rake::Task['test:profile'].comment = 'Profile the performance tests'
end

task :environment do
  require(File.join(File.expand_path(File.dirname(__FILE__) + '/../../../config'), 'environment'))
end
begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name = "redmine_data_generator"
    s.summary = "The Redmine Data Generator plugin is used to quickly generate a bunch of data for Redmine."
    s.email = "edavis@littlestreamsoftware.com"
    s.homepage = "https://projects.littlestreamsoftware.com/projects/TODO"
    s.description = "The Redmine Data Generator plugin is used to quickly generate a bunch of data for Redmine."
    s.authors = ["Eric Davis"]
    s.rubyforge_project = "redmine_data_generator" # TODO
    s.files =  FileList[
                        "[A-Z]*",
                        "init.rb",
                        "rails/init.rb",
                        "{bin,generators,lib,test,app,assets,config,lang}/**/*",
                        'lib/jeweler/templates/.gitignore'
                       ]
  end
  Jeweler::GemcutterTasks.new
  Jeweler::RubyforgeTasks.new do |rubyforge|
    rubyforge.doc_task = "rdoc"
  end
rescue LoadError
  puts "Jeweler, or one of its dependencies, is not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end

