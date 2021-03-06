require_relative 'boot'

require 'rails/all'

# ahc https://github.com/activerecord-hackery/ransack
require File.expand_path('../boot', __FILE__)
ENV['RANSACK_FORM_BUILDER'] = '::SimpleForm::FormBuilder'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Idoimaging
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # ahc
    config.assets.paths << Rails.root.join('vendor', 'assets', 'components')

    # ahc 1/14/19 include /lib path for modules  http://bit.ly/2QLynJn
    config.autoload_paths += %W(#{config.root}/lib)

    # ahc 2/22/17 Handle CORS now I have assets coming from cdn.idoimaging.com
    # http://bit.ly/2lvSKfw

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*', :headers => :any, :methods => [:get, :post, :options]
      end
    end

  end
end
