class Image < ActiveRecord::Base
  belongs_to :imageable, polymorphic: true
  mount_uploader :image, ImageUploader

  PROGRAM_CAPTURE ||= 'program_capture'
  PROGRAM_LOGO    ||= 'program_logo'
  IMAGE_TYPES = [PROGRAM_CAPTURE, PROGRAM_LOGO]
end
