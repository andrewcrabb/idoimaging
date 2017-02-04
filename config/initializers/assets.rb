# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )

# ahc  http://bit.ly/2cs2PKA
# Rails.application.config.assets.precompile += %w( modernizr.js )
Rails.application.config.assets.precompile += %w( jquery.star-rating-svg.js )
Rails.application.config.assets.precompile += %w( star-rating-svg.css )
Rails.application.config.assets.precompile += %w( my_rating.js )
Rails.application.config.assets.precompile += %w( my_slick.js )
Rails.application.config.assets.precompile += %w( my_google_analytics.js )
