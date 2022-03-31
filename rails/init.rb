require 'redmine'

Redmine::Plugin.register :redmine_data_generator do
  name 'Data Generator'
  author 'Eric Davis, Alex Abramov, Alex Pavic'
  url 'https://github.com/acosonic/redmine_data_generator'
  author_url 'https://github.com/acosonic'
  description 'The Redmine Data Generator plugin is used to quickly generate a bunch of data for Redmine.'
  version '0.2.0'

  requires_redmine :version_or_higher => '0.8.0'
end
