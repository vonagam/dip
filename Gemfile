source 'https://rubygems.org'

#core
gem 'rails', '4.0.1'
gem 'mongoid'

#front

# hadlers
gem 'slim-rails'
gem 'stylus'
gem 'coffee-rails'

# assets
gem 'jquery-rails'
gem 'vonagam_items', path: '../items'

# helpers
gem 'simple_form'

# various
gem 'uglifier'

#middle
gem 'rails-i18n'
gem 'russian'

gem 'activeadmin',         github: 'gregbell/active_admin'
gem 'activeadmin-mongoid', github: 'elia/activeadmin-mongoid', branch: 'rails4'

gem 'websocket-rails'

#back
gem 'cancancan', '~> 1.8'
gem 'devise'

gem 'rest-client'

gem 'delayed_job_mongoid'
gem 'daemons'


group :development do
  gem 'quiet_assets'
  #gem 'rails-i18n-debug'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
end

group :test do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'selenium-webdriver'
  gem 'rack'
end

#gem 'remotipart'
#gem 'paperclip', '~> 3.0'
#gem 'jbuilder'
