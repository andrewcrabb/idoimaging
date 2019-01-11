class ResourceType < ActiveRecord::Base
  has_many :resources

  BLOG_URL        ||= 'blog_url'        # program/show
  BLOG_ENTRY      ||= 'blog_entry'      # resource string
  COUNT_URL       ||= 'count_url'
  FACEBOOK        ||= 'facebook'        # program/show
  FORUM           ||= 'forum'           # resource string
  GITHUB          ||= 'github'          # program/show
  HOME_URL        ||= 'home_url'        # program/show
  IDI_BLOG_ENTRY  ||= 'idi_blog_entry'  # resource string
  IDI_DEMO        ||= 'idi_demo'        # resource string
  IDI_WIKI_ENTRY  ||= 'idi_wiki_entry'  # resource string
  REV_URL         ||= 'rev_url'
  SOURCE_URL      ||= 'source_url'      # program/show
  TWITTER         ||= 'twitter'         # program/show
  VIDEO_URL       ||= 'video_url'       # resource string
  WEB_DEMO        ||= 'web_demo'        # resource string
  WIKI            ||= 'wiki'            # resource string

  SOCIAL_HANDLE_PATTERNS = {
    twitter:  %r{twitter.com/(?<handle>[^/]+)},
    facebook: %r{facebook.com/(?<handle>[^/]+)},
    github:   %r{github.com/(?<handle>[^/]+)},
  }

  # These resources are displayed in a Program's resource list rather than individually.
  RESOURCE_TYPES = [BLOG_ENTRY, FORUM, IDI_BLOG_ENTRY, IDI_DEMO, IDI_WIKI_ENTRY, VIDEO_URL, WEB_DEMO, WIKI]

  scope :blog          , -> { where(name: BLOG_URL       ) }  # Blog belonging to a program or person
  scope :blog_entry    , -> { where(name: BLOG_ENTRY     ) }  # Post in third-party blog about a program
  scope :count_url     , -> { where(name: COUNT_URL      ) }
  scope :facebook      , -> { where(name: FACEBOOK       ) }
  scope :forum         , -> { where(name: FORUM          ) }
  scope :github        , -> { where(name: GITHUB         ) }
  # scope :home_url      , -> { where(name: HOME_URL       ) }
  scope :home_url      , -> { where(name: HOME_URL       ) }
  scope :idi_blog_enty , -> { where(name: IDI_BLOG_ENTRY ) }  # Post in IDI blog
  scope :idi_demo      , -> { where(name: IDI_DEMO       ) }
  scope :idi_wiki_entry, -> { where(name: IDI_WIKI_ENTRY ) }
  scope :rev_url       , -> { where(name: REV_URL        ) }
  scope :source_url    , -> { where(name: SOURCE_URL     ) }
  scope :twitter       , -> { where(name: TWITTER        ) }
  scope :video_url     , -> { where(name: VIDEO_URL      ) }
  scope :web_demo      , -> { where(name: WEB_DEMO       ) }
  scope :wiki          , -> { where(name: WIKI           ) }

  def self.selector_values
    all.order(:name).pluck(:name, :id)
  end

  def self.id_of(name)
    recs = where(name: name)
    return recs.count.eql?(1) ? recs.first.id : nil
  end
end
