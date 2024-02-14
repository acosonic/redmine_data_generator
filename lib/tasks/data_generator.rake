namespace :data_generator do
  desc "Generates random data for all supported datatypes"
  task :all => [:environment, :users, :projects, :issues, :issue_history, :time_entries]
  
  desc "Generate random issues.  Default: 100, override with COUNT=x"
  task :issues => :environment do
    DataGenerator.issues ENV['COUNT'] || 100
    puts "#{Issue.count} issues total"
  end

  desc "Generate random issue history for several issues.  Default: 500, override with COUNT=x"
  task :issue_history => :environment do
    DataGenerator.issue_history ENV['COUNT'] || 500
  end

  desc "Generate random projects.  Default: 15, override with COUNT=x"
  task :projects => :environment do
    DataGenerator.projects ENV['COUNT'] || 15
    puts "#{Project.count} projects total"
  end

  desc "Generate random time entries.  Default: 100, override with COUNT=x"
  task :time_entries => :environment do
    DataGenerator.time_entries ENV['COUNT'] || 100
  end

  desc "Generate random users.  Default: 15, override with COUNT=x"
  task :users => :environment do
    DataGenerator.users ENV['COUNT'] || 15 
    puts "#{User.count} users total"
  end
end
