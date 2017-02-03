class WriteProgramImageFormat < ActiveRecord::Base
  belongs_to :program
  belongs_to :image_format
end
