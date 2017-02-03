class Feature < ActiveRecord::Base
  has_many :program_features
  has_many :programs, through: :program_features
  has_many :resources, as: :resourceful

  # Categories of Feature instances

  FUNCTION            ||= 'Function'
  CONVERSION  ||= 'Conversion'
  DISPLAY     ||= 'Display'
  HEADER      ||= 'Header'
  NETWORK     ||= 'Network'
  OTHER       ||= 'Other'
  PROGRAMMING ||= 'Programming'

  FUNCTIONS ||= [OTHER, DISPLAY, HEADER, NETWORK, CONVERSION, PROGRAMMING]

  AUDIENCE     ||= 'Audience'
  DISTRIBUTION ||= 'Distribution'
  IMAGE        ||= 'Image'
  INTERFACE    ||= 'Interface'
  LANGUAGE     ||= 'Language'
  OTHER        ||= 'Other'
  PLATFORM     ||= 'Platform'
  SPECIALITY   ||= 'Speciality'

  AUDIENCE_ADVANCED_USER ||= 'Advanced user'
  AUDIENCE_GENERAL_USER  ||= 'General user'
  AUDIENCE_PROGRAMMER    ||= 'Programmer'

  # Search levels: Which Features to include at Basic or Advanced search levels
  FOR_AUDIENCE          ||= 'for_audience'
  SEARCH_LEVEL          ||= 'search_level'
  SEARCH_LEVEL_BASIC    ||= 'basic'
  SEARCH_LEVEL_ADVANCED ||= 'advanced'
  SEARCH_LEVELS ||= [SEARCH_LEVEL_BASIC, SEARCH_LEVEL_ADVANCED]

  scope :basic   , -> { where search_level: SEARCH_LEVEL_BASIC }
  scope :advanced, -> { where search_level: SEARCH_LEVEL_ADVANCED }

  # scope :functions             , -> { where("category like '_%'").order(:category)}
  scope :functions             , -> { where(category: FUNCTION           ).order(:category)}
  scope :other_functions       , -> { where(category: OTHER      ).order(:value)}
  scope :conversion_functions  , -> { where(category: CONVERSION ).order(:value)}
  scope :display_functions     , -> { where(category: DISPLAY    ).order(:value)}
  scope :header_functions      , -> { where(category: HEADER     ).order(:value)}
  scope :network_functions     , -> { where(category: NETWORK    ).order(:value)}
  scope :programming_functions , -> { where(category: PROGRAMMING).order(:value)}

  scope :audience_features    , -> { where(category: AUDIENCE         ).order(:value)}
  scope :distributions        , -> { where(category: DISTRIBUTION     ).order(:value)}
  scope :interfaces           , -> { where(category: INTERFACE        ).order(:value)}
  scope :languages            , -> { where(category: LANGUAGE         ).order(:value)}
  scope :other_features       , -> { where(category: OTHER            ).order(:value)}
  scope :platforms            , -> { where(category: PLATFORM         ).order(:value)}
  scope :specialities         , -> { where(category: SPECIALITY       ).order(:value)}
  scope :audiences            , -> { where(category: AUDIENCE         ).order(:value)}

  scope :platform, ->(id) { where(id: id)}
  scope :interface, ->(id) { where(id: id)}

  def self.categories
    pluck(:category).uniq.sort
  end

  def self.selector_values(category)
    where(category: category).map{ |f| [f.value, f.id] }.sort{ |e, f| e[0].upcase <=> f[0].upcase }
  end

  def self.has_value(value)
    rec = find_by(value: value)
    return rec ? rec.id : nil;
  end

  def category_value
    "#{category}: #{value}"
  end

  def is_feature?
    !is_function?
  end

  def is_function?
    FUNCTIONS.include? category
  end

end
