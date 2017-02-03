class ImageFormat < ActiveRecord::Base
  has_many :read_program_image_formats
  has_many :write_program_image_formats
  has_many :read_programs , through: :read_program_image_formats , source: :program
  has_many :write_programs, through: :write_program_image_formats, source: :program
  has_many :resources                      , as: :resourceful, dependent: :destroy

  accepts_nested_attributes_for :resources             , allow_destroy: true

  # Search levels: Which ImageFormats to include at Basic or Advanced search levels
  SEARCH_LEVEL_BASIC    = 'basic'
  SEARCH_LEVEL_ADVANCED = 'advanced'
  SEARCH_LEVELS = [SEARCH_LEVEL_BASIC, SEARCH_LEVEL_ADVANCED]

  scope :basic   , -> { where search_level: SEARCH_LEVEL_BASIC }
  scope :advanced, -> { where search_level: SEARCH_LEVEL_ADVANCED }

  # Return array of [value, id] for all image formats, suitable for selector
  # 
  # @return [Array<String, Fixnum>]

  def self.selector_values
    order(:name).map { |f| [f.name , f.id] }
  end

end
