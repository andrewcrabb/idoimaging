source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'

gem 'rails'
# Use sqlite3 as the database for Active Record
# gem 'sqlite3'
# Use Puma as the app server
# gem 'puma', '~> 3.0'
gem 'puma'
# Use SCSS for stylesheets
# gem 'sass-rails', '~> 5.0'
# gem 'sass-rails'
# ahc 10/15/18 sass is deprecated http://sass.logdown.com/posts/7081811
gem 'sassc-rails'
# activeadmin requires sass (but not sass-rails)  https://github.com/activeadmin/activeadmin/issues/5031
# gem 'sass'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
# gem 'coffee-rails', '~> 4.2'
gem 'coffee-rails'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
# gem 'turbolinks', '~> 5'
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.5'
gem 'jbuilder'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# ahc
gem 'bootstrap', '~> 4.1.3'
# gem 'bootstrap', '~> 4.0.0'
# gem 'bootstrap'
gem 'pg'
gem 'minitest-reporters'
gem 'high_voltage'
# Take this one out when sprockets is fixed
# https://github.com/rails/sass-rails/issues/381
# gem 'sprockets', '3.6.3'
gem 'sprockets'
# ahc 10/15/18 https://github.com/plataformatec/devise/issues/4511
gem 'devise', git: 'https://github.com/plataformatec/devise.git', branch: 'master'
# gem 'devise'
gem 'kaminari'
# ---------------------------  Temp due to error messages after upgrade  --------------------------------------
# gem 'activeadmin', github: 'activeadmin'
# Everyone likes their own brand.
gem 'activeadmin', github: 'idoimaging/activeadmin'
# gem 'activeadmin'
# ---------------------------  Temp  --------------------------------------
gem 'country_select'
gem 'letter_opener', :group => :development
# gem 'cancancan', '~> 1.10'
gem 'cancancan'
gem 'mini_magick'
gem 'carrierwave-aws'
gem 'ransack', github: 'activerecord-hackery/ransack'
# gem 'compass-rails', github: 'Compass/compass-rails'
# gem 'compass-rails', '~> 3.1.0'
gem 'simple_form'
gem 'octokit'
gem 'rb-readline'
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
# ahc 10/15/18 u_a used only once, in aa, and was causing dependency problem.
# gem 'unscoped_associations'
# gem "just-datetime-picker"
# gem 'rails-assets-tether'
gem 'concurrent-ruby'
gem 'rails-i18n'
gem 'thread_safe'
gem 'tether-rails'
gem 'record_tag_helper'
gem 'json'
# I had to disable this in application.scss
gem 'devise-bootstrap-views'
gem "recaptcha", require: "recaptcha/rails"
gem "figaro"
gem 'rack-cors', :require => 'rack/cors'
gem 'pg_search'
gem 'audited'
gem 'binding_of_caller'
gem 'listen'

gem 'rack-mini-profiler', require: false
gem 'memory_profiler'
gem 'flamegraph'
gem 'stackprof'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  # gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  # gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'spring-watcher-listen'
  # ahc
  gem 'capistrano'
  gem 'capistrano-rails'
  gem 'capistrano-passenger'
  gem 'mysql2'  # ActiveAdmin dependency.  NO WAY AM I INSTALLING THIS IN PRODUCTON.
  gem "better_errors"
  gem 'passenger'


    gem 'capistrano-rbenv',     require: false
    gem 'capistrano-rails',   require: false
    gem 'capistrano-bundler', require: false
    gem 'capistrano3-puma',   require: false

end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
