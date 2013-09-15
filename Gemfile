source 'https://rubygems.org'

gem 'rails'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

group :development do
  gem 'sqlite3'
	gem 'rails-erd'
	gem 'foreman'
	gem 'rack-mini-profiler'
end

gem 'guard-rspec', :group => [:test, :development]
gem 'guard-zeus', :group => [:test, :development]
gem 'rspec-rails', :group => [:test, :development]
gem 'factory_girl_rails', :group => [:test, :development]
group :test do
  gem 'rake'
  gem 'capybara'
  gem 'capybara-webkit'
  gem 'rack_session_access'
end

group :production do
 # gem 'pg'
 gem 'mysql2'
end

gem 'thin'
gem 'rdiscount'
gem 'activeadmin'#, git: 'git://github.com/maknoll/active_admin.git'
gem 'rails-i18n'
gem 'fnordmetric'
#gem 'gollum'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'compass-rails'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer'
  gem 'uglifier'
  gem 'bootstrap-sass'
  gem 'jquery-popover'
end

gem 'chosen-rails'

gem "jquery-rails", "2.3.0"

# To use ActiveModel has_secure_password
gem 'bcrypt-ruby'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

#Configuration
gem "rails_config"

#A nicer Way to use forms
gem 'formtastic'

#Restful library for in Place editing
gem 'best_in_place', git: 'git://github.com/renemeye/best_in_place.git'

#Markdown support from Github
gem 'redcarpet'

#Plotting in Javascrript
gem 'flot-rails'

gem 'mathjax-rails'

gem 'habtm_generator', :group => :development

gem 'delayed_job_active_record'

gem 'prawn', :git => 'git://github.com/prawnpdf/prawn.git'#, :tag => '1.0.0.rc2'

gem "carrierwave"
gem 'rails-file-icons'
