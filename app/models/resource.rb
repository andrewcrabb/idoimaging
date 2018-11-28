class Resource < ActiveRecord::Base
  audited

  GITHUB_PATTERN = %r{github.com/(?<user>[\w\.\-]+)/(?<repo>[\w\.\-]+)}

  # 'identifier' field stores identifying text for testing the url.

  belongs_to :resourceful, polymorphic: true
  belongs_to :resource_type
  has_many   :redirects
  validates  :resource_type, presence: true

  validate :url_must_be_valid

  def url_must_be_valid
    if url.nil?
      errors.add(:url, "can't be nil")
    else
      github_id = ResourceType.id_of(ResourceType::GITHUB)
      # github_id = ResourceType.find_by(name: ResourceType::GITHUB).id
      if resource_type_id.eql? github_id and not GITHUB_PATTERN.match url
        errors.add(:url, "must match https://github.com/foo/bar for resource type github")
      end
    end

  end

  def is_github?
    puts "resource_type_id is #{resource_type_id}"
    resource_type_id.eql? 9
  end

  scope :blogs           , -> { includes(:resource_type).where(resource_types: {name: ResourceType::BLOG_URL}) }
  scope :count_urls      , -> { includes(:resource_type).where(resource_types: {name: ResourceType::COUNT_URL}) }
  scope :facebooks       , -> { includes(:resource_type).where(resource_types: {name: ResourceType::FACEBOOK}) }
  scope :forums          , -> { includes(:resource_type).where(resource_types: {name: ResourceType::FORUM}) }
  scope :githubs         , -> { includes(:resource_type).where(resource_types: {name: ResourceType::GITHUB}) }
  scope :home_urls       , -> { includes(:resource_type).where(resource_types: {name: ResourceType::HOME_URL}) }
  scope :idi_blog_entries, -> { includes(:resource_type).where(resource_types: {name: ResourceType::IDI_BLOG_ENTRY}) }
  scope :idi_demos       , -> { includes(:resource_type).where(resource_types: {name: ResourceType::IDI_DEMO}) }
  scope :idi_wiki_entries, -> { includes(:resource_type).where(resource_types: {name: ResourceType::IDI_WIKI_ENTRY}) }
  scope :rev_urls        , -> { includes(:resource_type).where(resource_types: {name: ResourceType::REV_URL}) }
  scope :source_urls     , -> { includes(:resource_type).where(resource_types: {name: ResourceType::SOURCE_URL}) }
  scope :twitters        , -> { includes(:resource_type).where(resource_types: {name: ResourceType::TWITTER}) }
  scope :video_urls      , -> { includes(:resource_type).where(resource_types: {name: ResourceType::VIDEO_URL}) }
  scope :web_demos       , -> { includes(:resource_type).where(resource_types: {name: ResourceType::WEB_DEMO}) }
  scope :of_programs     , -> { where(resourceful_type: "Program") }
  scope :github          , -> { where("url like '%github%'") }

  scope :of_program      , ->(prog_id)   { where(resourceful_type: "Program", resourceful_id: prog_id) }
  scope :of_author       , ->(auth_id)   { where(resourceful_type: "Author" , resourceful_id: auth_id) }
  scope :of_image_format , ->(format_id) { where(resourceful_type: "ImageFormat" , resourceful_id: format_id) }

  def icon
    resource_type.icon
  end

  def icon_prefix
    resource_type.icon_prefix
  end

  def full_url
    url.match(%r{^http}) ? url : "http://#{url}"
  end

  def short_url
    url = full_url.gsub(%r'http[s]*://', '')
    (url.length > 28) ? url[0..13] + '...' + url[-14..-1] : url
  end

  # If a GitHub resource and url is valid, return MatchData with fields :user, :repo
  # Else return nil

  def github_details
    return url ? url.match(GITHUB_PATTERN) : nil
  end

end
