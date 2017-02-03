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

  scope :blog          , -> { find_by(name: BLOG_URL       ) }  # Blog belonging to a program or person
  scope :blog_entry    , -> { find_by(name: BLOG_ENTRY     ) }  # Post in third-party blog about a program
  scope :count_url     , -> { find_by(name: COUNT_URL      ) }
  scope :facebook      , -> { find_by(name: FACEBOOK       ) }
  scope :forum         , -> { find_by(name: FORUM          ) }
  scope :github        , -> { find_by(name: GITHUB         ) }
  scope :home_url      , -> { find_by(name: HOME_URL       ) }
  scope :idi_blog_enty , -> { find_by(name: IDI_BLOG_ENTRY ) }  # Post in IDI blog
  scope :idi_demo      , -> { find_by(name: IDI_DEMO       ) }
  scope :idi_wiki_entry, -> { find_by(name: IDI_WIKI_ENTRY ) }
  scope :rev_url       , -> { find_by(name: REV_URL        ) }
  scope :source_url    , -> { find_by(name: SOURCE_URL     ) }
  scope :twitter       , -> { find_by(name: TWITTER        ) }
  scope :video_url     , -> { find_by(name: VIDEO_URL      ) }
  scope :web_demo      , -> { find_by(name: WEB_DEMO       ) }
  scope :wiki          , -> { find_by(name: WIKI           ) }

  def self.selector_values
    all.order(:name).pluck(:name, :id)
  end
end
