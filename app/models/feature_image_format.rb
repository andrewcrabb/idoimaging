class FeatureImageFormat < ActiveRecord::Base
  belongs_to :feature
  belongs_to :image_format
end
