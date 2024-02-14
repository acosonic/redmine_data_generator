require 'faker'
require 'random_data'

class DataGenerator
  UserStatuses = [User::STATUS_ACTIVE, User::STATUS_REGISTERED, User::STATUS_LOCKED]

  # Generate issues
  def self.issues(count=100)
    projects = Project.all
    status = IssueStatus.all
    priorities = IssuePriority.all
    users = User.all
    trackers = Tracker.all
    
    count.to_i.times do |i|
      project = projects.sample
      parent_id = if [true, false].sample && project.issues.count > 0
                    project.issues.sample.try(:id)
                  end
      
      issue = Issue.new(
                        :tracker => trackers.sample,
                        :project => project,
                        :subject => Faker::Company.catch_phrase,
                        :description => Random.paragraphs(3),
                        :status => status.sample,
                        :priority => priorities.sample,
                        :author => users.sample,
                        :assigned_to => users.sample,
                        :start_date => (1..120).to_a.sample.days.ago.to_date.to_s,
                        :due_date => (1..120).to_a.sample.days.from_now.to_date.to_s,
                        :parent_issue_id => parent_id
                        )
      unless issue.save
        Rails.logger.error issue.errors.full_messages
      end
    end

  end
  
  # Generate issues
  def self.issue_history(count=100)
    change_attributes = [:subject, :description, :priority, :status]
    status = IssueStatus.all
    priorities = IssuePriority.all
    
    issues = Issue.all.limit(count).order(:subject, id: :desc) # Semi-random sort
    issues.each do |issue|
      issue.reload # in case of stale object from subtasks
      User.current = issue.assignable_users.sample

      # Random changes
      issue.init_journal(User.current, Random.paragraphs(1))
      number_of_changes = (change_attributes.length / 2).floor
      number_of_changes.times do
        attribute_to_change = change_attributes.sample
        case attribute_to_change
        when :subject
          issue.subject = Faker::Company.catch_phrase
        when :description
          issue.description = Random.paragraphs(3)
        when :priority
          issue.priority = priorities.sample
        when :status
          issue.status = status.sample
        end
      end

      created_days_ago = (Date.today - issue.created_on.to_date).to_i
      update_date = (0..created_days_ago).to_a.sample # Random date since creation
      
      Timecop.freeze(update_date.days.ago) do
        unless issue.save
          Rails.logger.error issue.errors.full_messages
        end
      end
      Timecop.return
    end
    
  end

  # Generate projects and members
  def self.projects(count=5)
    count.to_i.times do |n|
      parent = if [true, false].sample && Project.count > 0
                 Project.all.sample
               end
                 
      project = Project.create(
                               :name => Faker::Company.catch_phrase[0..29],
                               :description => Faker::Company.bs,
                               :homepage => Faker::Internet.domain_name,
                               :identifier => Faker::Internet.domain_word[0..16] + n.to_s
                               )
      project.set_parent!(parent) if parent
      
      project.trackers = Tracker.all
      if project.save
        # Roles
        roles =  Role.all.reject {|role|
          role.builtin == Role::BUILTIN_NON_MEMBER || role.builtin == Role::BUILTIN_ANONYMOUS
        }

        User.where(status: UserStatuses).each do |user|
          Member.create({:user => user, :project => project, :roles => [roles.sample]})
        end

        Redmine::AccessControl.available_project_modules.each do |module_name|
          EnabledModule.create(:name => module_name.to_s, :project => project)
        end
      else
        Rails.logger.error project.errors.full_messages
      end
    end
  end

  # Generate time entries
  def self.time_entries(count=100)
    users = User.all
    issues = Issue.all
    activities = TimeEntryActivity.all
      
    count.to_i.times do
      issue = issues.sample
      te = TimeEntry.new(
                       :project => issue.project,
                       :user => users.sample,
                       :issue => issue,
                       :hours => (1..20).to_a.sample,
                       :comments => Faker::Company.bs,
                       :activity => activities.sample,
                       :spent_on => Random.date
                         )
      unless te.save
        Rails.logger.error te.errors.full_messages
      end
    end
 
  end
  
  # Generate user accounts
  def self.users(count=5)
    count.to_i.times do
      user = User.new(
                      :firstname => Faker::Name.first_name,
                      :lastname => Faker::Name.last_name,
                      :mail => Faker::Internet.email,
                      :status => User::STATUS_ACTIVE
                      )
      # Protected from mass assignment
      user.login = Faker::Internet.user_name
      user.password = 'demoomed'
      user.password_confirmation = 'demoomed'
      user.save
    end
  end
end
