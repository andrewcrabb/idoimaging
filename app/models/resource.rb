class Resource < ActiveRecord::Base
  audited

  GITHUB_PATTERN = %r{github.com/(?<user>[\w\.\-]+)/(?<repo>[\w\.\-]+)}

  belongs_to :resourceful, polymorphic: true
  belongs_to :resource_type
  # has_many :programs, -> { where resourceful_type: "Program" }, foreign_key: :resource_ids

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

  # All of these used to be 'includes'
  scope :blogs           , -> { joins(:resource_type).merge(ResourceType.blog)}
  scope :count_urls      , -> { joins(:resource_type).merge(ResourceType.count_url )}
  scope :facebooks       , -> { joins(:resource_type).merge(ResourceType.facebook )}
  scope :forums          , -> { joins(:resource_type).merge(ResourceType.forum )}
  scope :githubs         , -> { joins(:resource_type).merge(ResourceType.github) }
  scope :home_urls       , -> { joins(:resource_type).merge(ResourceType.home_url )}
  scope :idi_blog_entries, -> { joins(:resource_type).merge(ResourceType.idi_blog_entry )}
  scope :idi_demos       , -> { joins(:resource_type).merge(ResourceType.idi_demo )}
  scope :idi_wiki_entries, -> { joins(:resource_type).merge(ResourceType.idi_wiki_entry )}
  scope :rev_urls        , -> { joins(:resource_type).merge(ResourceType.rev_url )}
  scope :source_urls     , -> { joins(:resource_type).merge(ResourceType.source_url )}
  scope :twitters        , -> { joins(:resource_type).merge(ResourceType.twitter )}
  scope :video_urls      , -> { joins(:resource_type).merge(ResourceType.video_url )}
  scope :web_demos       , -> { joins(:resource_type).merge(ResourceType.web_demo )}
  scope :of_programs     , -> { where(resourceful_type: "Program") }
  scope :githubs         , -> { where("url like '%github%'") }
  scope :bitbuckets      , -> { where("url like '%bitbucket%'") }
  scope :not_githubs     , -> { where.not("url like '%github%'") }

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

  def github?
    url.include? 'github'
  end

  def bitbucket?
    url.include? 'bitbucket'
  end
end
