source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.1'
# Use sqlite3 as the database for Active Record
# gem 'sqlite3'
# Use Puma as the app server
gem 'puma', '~> 3.0'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# ahc
# gem 'bootstrap', '~> 4.0.0.alpha6'
gem 'pg'
gem 'minitest-reporters'
gem 'high_voltage'
# Take this one out when sprockets is fixed
# https://github.com/rails/sass-rails/issues/381
# gem 'sprockets', '3.6.3'
gem 'sprockets'
gem 'devise'
gem 'cancancan', '~> 1.10'
gem 'kaminari'
gem 'activeadmin', github: 'activeadmin'
gem 'country_select'
gem 'letter_opener', :group => :development
gem 'carrierwave', '>= 1.0.0.rc', '< 2.0'
gem 'mini_magick'
gem 'carrierwave-aws'
gem 'ransack', github: 'activerecord-hackery/ransack'
gem 'compass-rails'
gem 'simple_form'
# Won't install.
# gem 'quiet_assets', group: :development
gem 'haml'
gem 'haml-rails'
gem 'select2-rails'
  # Gives infinite loop
# gem 'activeadmin-select2', github: 'mfairburn/activeadmin-select2'
gem 'rdiscount'
gem 'twitter'
gem 'jquery-ui-rails'
gem 'lograge'
gem 'unscoped_associations'
# gem "just-datetime-picker"
# gem 'rails-assets-tether'
gem 'concurrent-ruby'
gem 'rails-i18n'
gem 'thread_safe'
gem 'tether-rails'
gem 'record_tag_helper'
gem 'json'
gem 'devise-bootstrap-views'
gem "recaptcha", require: "recaptcha/rails"
gem "figaro"
gem 'rack-cors', :require => 'rack/cors'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  # ahc
  gem 'capistrano'
  gem 'capistrano-rails'
  gem 'capistrano-passenger'
  gem 'mysql2'  # ActiveAdmin dependency.  NO WAY AM I INSTALLING THIS IN PRODUCTON.
  gem "better_errors"

end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
