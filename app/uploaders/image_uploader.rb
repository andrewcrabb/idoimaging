class ImageUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  require 'carrierwave/processing/mini_magick'
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  # storage :file
  # storage :fog

  if Rails.env.development?
    storage :file
  else
    storage :aws
  end

  # storage :aws

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    # "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    "images/#{model.id}"
  end

  # def full_original_filename
  #   parent_name = super
  #   extension = File.extname(parent_name)
  #   base_name = parent_name.chomp(extension)
  #   [base_name, version_name].compact.join("_") + extension
  # end

  # def filename
  #   m = super.match(/^prog_(\d+)_([^_]+)_(\d)_(\d+)_(\d+)\.(.+)$/)
  #   # <MatchData "prog_102_emma_0_560_420.jpg" 1:"102" 2:"emma" 3:"0" 4:"560" 5:"420" 6:"jpg">
  #   m ? sprintf("%s_%s.%s",  m[2], m[3], m[6]) : 'program.jpg'
  # end

  # def filename
  #   model.name.to_s.underscore
  # end

  def filename
    puts "*** model is #{model.inspect}"
    puts "*** super is #{super}"
    m = super.match(/^prog_(\d+)_([^_]+)_(\d)_(\d+)_(\d+)\.(.+)$/)
    # <MatchData "prog_102_emma_0_560_420.jpg" 1:"102" 2:"emma" 3:"0" 4:"560" 5:"420" 6:"jpg">
    m ? sprintf("%s_%s.%s",  m[2], m[3], m[6]) : 'program.jpg'
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process scale: [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  version :thumb do
    process resize_to_fit: [150, 150]
  end
  version :px350 do
    process resize_to_fit: [350, 350]
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_whitelist
  #   %w(jpg jpeg gif png)
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

end
