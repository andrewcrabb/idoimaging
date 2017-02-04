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

  end
end
