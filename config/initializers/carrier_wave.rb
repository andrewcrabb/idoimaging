require 'carrierwave/orm/activerecord'

CarrierWave.configure do |config|
  # if Rails.env.development?
  #   config.storage = :file
  #   config.root = "#{Rails.root}/public"
  #   config.cache_dir = "#{Rails.root}/tmp/images"
  # elsif Rails.env.test?
  #   config.storage = :file
  # else
    config.storage    = :aws
    config.aws_bucket = 'idoimaging-images'
    config.aws_acl    = 'public-read'

    # The maximum period for authenticated_urls is only 7 days.
    config.aws_authenticated_url_expiration = 60 * 60 * 24 * 7

    # Set custom options such as cache control to leverage browser caching
    config.aws_attributes = {
      expires: 1.week.from_now.httpdate,
      cache_control: 'max-age=604800'
    }

    config.aws_credentials = {
      access_key_id:     ENV["carrier_wave_key_id"],
      secret_access_key: ENV["carrier_wave_secret_key"],
      region:            'us-east-1'
    }
  # end
end
