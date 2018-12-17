class Program < ActiveRecord::Base
  audited
  include PgSearch
  pg_search_scope :search_for,
    against: {name: 'A', summary: 'B', description: 'C'},
  using: {
    tsearch: {
      highlight: {
        StartSel: '<span class="fulltext_highlight">',
        StopSel: '</span>',
        MaxWords: 15,
        MinWords: 4,
        ShortWord: 3,
        HighlightAll: false,
        MaxFragments: 3,
        FragmentDelimiter: '&nbsp;&hellip;&nbsp;'
      },
      dictionary: "english",
    }
  }
  require_relative './feature'

  has_many :author_programs, dependent: :destroy
  has_many :authors, through: :author_programs
  has_many :program_features
  has_many :features, through: :program_features
  has_many :read_program_image_formats
  has_many :write_program_image_formats
  has_many :read_image_formats, through: :read_program_image_formats, source: :image_format
  has_many :write_image_formats, through: :write_program_image_formats, source: :image_format
  has_many :images, as: :imageable, dependent: :destroy
  has_many :ratings, dependent: :destroy
  has_many :users, through: :ratings
  has_many :versions       , -> { order('date DESC') }, dependent: :destroy
  has_many :latest_versions, -> { latest(3) }, class_name: 'Version'
  has_one  :latest_version , -> { latest(1) }, class_name: 'Version'

  # Functions (Feature category = 'function')
  # The lambda on the association is called on the linked class (Feature).  I got it from http://bit.ly/2UOkAFm and http://bit.ly/2PDJAep
  has_many :audience_features    , -> { audience_features     }, through: :program_features, source: :feature
  has_many :audiences            , -> { audiences             }, through: :program_features, source: :feature
  has_many :conversion_functions , -> { conversion_functions  }, through: :program_features, source: :feature
  has_many :display_functions    , -> { display_functions     }, through: :program_features, source: :feature
  has_many :distributions        , -> { distributions         }, through: :program_features, source: :feature
  has_many :functions            , -> { functions             }, through: :program_features, source: :feature
  has_many :header_functions     , -> { header_functions      }, through: :program_features, source: :feature
  has_many :interfaces           , -> { interfaces            }, through: :program_features, source: :feature
  has_many :languages            , -> { languages             }, through: :program_features, source: :feature
  has_many :network_features     , -> { network_features      }, through: :program_features, source: :feature
  has_many :network_functions    , -> { network_functions     }, through: :program_features, source: :feature
  has_many :other_features       , -> { other_features        }, through: :program_features, source: :feature
  has_many :other_functions      , -> { other_functions       }, through: :program_features, source: :feature
  has_many :platforms            , -> { platforms             }, through: :program_features, source: :feature
  has_many :programming_functions, -> { programming_functions }, through: :program_features, source: :feature
  has_many :specialities         , -> { specialities          }, through: :program_features, source: :feature

  # has_many :platforms            , -> { where(category: "Platform") },through: :program_features, source: :feature
  # has_many :platforms            , ->(id = nil) { platforms(id) },through: :program_features, source: :feature
  # has_many :functions            , -> { where(category: "Function") },through: :program_features, source: :feature
  # has_many :functions            , ->(id = nil) { functions(id) },through: :program_features, source: :feature


  has_many :resources                      , as: :resourceful, dependent: :destroy
  has_many :source_urls, -> { source_urls }, as: :resourceful, class_name: 'Resource'
  has_many :home_urls  , -> { home_urls   }, as: :resourceful, class_name: 'Resource'
  has_many :rev_urls   , -> { rev_urls    }, as: :resourceful, class_name: 'Resource'
  has_many :count_urls , -> { count_urls  }, as: :resourceful, class_name: 'Resource'
  has_many :resource_types, through: :resources

  # IDI administrator is the only user with multiple rating types
  # overall breadth scale website appearance)
  has_one :appearance_rating, -> { appearance }, class_name: 'Rating'
  has_one :breadth_rating   , -> { breadth    }, class_name: 'Rating'
  has_one :overall_rating   , -> { overall    }, class_name: 'Rating'
  has_one :scale_rating     , -> { scale      }, class_name: 'Rating'
  has_one :website_rating   , -> { website    }, class_name: 'Rating'

  RELATIONSHIPS = {
    included:   'Includes',
    including:  'Included by',
    collected:  'Members',
    collecting: 'Member of',
    related:    'Related to',
    relating:   'Related by',
    required:   'Requires',
    requiring:  'Required by',
  }

  # Programs upon which the current program is built
  has_many :program_components, -> { component }, class_name: "ProgramComponent", foreign_key: "including_program_id"
  has_many :included_programs, through: :program_components, source: :included_program

  # Programs building upon the current program
  has_many :inverse_components, -> { component }, class_name: "ProgramComponent", foreign_key: "included_program_id"
  has_many :including_programs, through: :inverse_components, source: :including_program

  # Programs included in the current collection program
  has_many :program_memberships, -> { member }, class_name: "ProgramComponent", foreign_key: "including_program_id"
  has_many :collected_programs, through: :program_memberships, source: :included_program

  # Programs that are collections including the current program
  has_many :inverse_memberships, -> { member }, class_name: "ProgramComponent", foreign_key: "included_program_id"
  has_many :collecting_programs, through: :inverse_memberships, source: :including_program

  # Programs required by the current program
  has_many :program_requirements, -> { requirement }, class_name: "ProgramComponent", foreign_key: "including_program_id"
  has_many :required_programs, through: :program_requirements, source: :included_program

  # Programs that require the current program
  has_many :inverse_requirements, -> { requirement }, class_name: "ProgramComponent", foreign_key: "included_program_id"
  has_many :requiring_programs, through: :inverse_requirements, source: :including_program

  # 'related' is non-directional, but re-using the existing mechanism
  # Programs which the current program is related to
  has_many :program_relations, -> { related }, class_name: "ProgramComponent", foreign_key: "including_program_id"
  has_many :related_programs, through: :program_relations, source: :included_program

  # Programs related to the current program
  has_many :inverse_relations, -> { related }, class_name: "ProgramComponent", foreign_key: "included_program_id"
  has_many :relating_programs, through: :inverse_relations, source: :including_program

  accepts_nested_attributes_for :read_program_image_formats, :write_program_image_formats
  accepts_nested_attributes_for :authors               , allow_destroy: true
  accepts_nested_attributes_for :author_programs       , allow_destroy: true
  accepts_nested_attributes_for :resources             , allow_destroy: true
  accepts_nested_attributes_for :images                , allow_destroy: true
  accepts_nested_attributes_for :program_components    , allow_destroy: true
  accepts_nested_attributes_for :inverse_components    , allow_destroy: true
  accepts_nested_attributes_for :program_memberships   , allow_destroy: true
  accepts_nested_attributes_for :inverse_memberships   , allow_destroy: true
  accepts_nested_attributes_for :program_relations     , allow_destroy: true
  accepts_nested_attributes_for :inverse_relations     , allow_destroy: true
  accepts_nested_attributes_for :program_requirements  , allow_destroy: true
  accepts_nested_attributes_for :inverse_requirements  , allow_destroy: true
  accepts_nested_attributes_for :versions              , allow_destroy: true
  accepts_nested_attributes_for :latest_versions              , allow_destroy: true
  accepts_nested_attributes_for :ratings   , allow_destroy: true
  accepts_nested_attributes_for :overall_rating
  accepts_nested_attributes_for :breadth_rating
  accepts_nested_attributes_for :scale_rating
  accepts_nested_attributes_for :website_rating
  accepts_nested_attributes_for :appearance_rating

  enum program_kinds: {k_imaging: 0, k_prerequisite: 1, k_software_group: 2}

  scope :active          , ->(yes = true) { yes ? where(remove_date: nil) : where.not(remove_date: nil) }
  scope :inactive        , -> { where.not(remove_date: nil) }
  scope :imaging         , -> { where(program_kind: program_kinds[:k_imaging]) }
  scope :prerequisite    , -> { where(program_kind: program_kinds[:k_prerequisite]) }
  scope :software_group  , -> { where(program_kind: program_kinds[:k_software_group]) }
  scope :imaging_or_group, -> { Program.where("program_kind = ? or program_kind = ?", program_kinds[:k_imaging], program_kinds[:k_software_group]) }

  # Default scope of active imaging programs means prerequisite queries must b
  # This was causing strange issues: Program.find(x).required_programs
  # returns non-empty association, but Program.find(x).required_programs.count returns 0!
  # default_scope { active.imaging }

  # Return programs for given X
  # All these are needed as ransackable_scopes though they do the same thing.
  # These are the scopes I've tried to use but failed.  Only the naiive one works.
  # includes(:features).where(features: {id: id}).references(:features) }
  # includes(:features).merge(Feature.platform(id)) }  # merge generates an array
  # includes(:features).where(features: {id: id}) }
  # joins(:features).where('features.id' => id) }  # Not chainable: searches for 'features.id = 1 and features.id = 2'
  # scope :for_feature,  -> (id)  { includes(:features).references(:features).merge(Feature.for_feature(id)) }
  # scope :ffor_feature         , ->(id) { where id: Feature.find(id).programs.pluck(:id) }
  # scope :fffor_feature         , ->(id) { includes(:features).references(:features).where feature: {id: id} }
  # scope :platform, ->(id) { includes(:platforms).references(:platforms).merge(Feature.platforms(id)) }
  # scope :function, ->(id) { includes(:functions).references(:functions).merge(Feature.functions(id)) }
  # scope :function , ->(id) { joins(:features).where(features: {id: id}).references(:features) }
  # scope :function , ->(id) { Feature.find(id).programs }
  # scope :function         , ->(id) { includes(:functions).where(features: {id: id, category: "Function"}).references(:features) }
  # scope :for_feature         , ->(id) { includes(:platforms, :resource_types, :resources).where(features: {id: id}) }
  # scope :for_platform        , ->(id) { (:features).where(features: {category: 'Platform', id: id}) }
  # scope :ffor_platform       , ->(id) { includes(:platforms).where(platforms: {id: id}).references(:features) }
  # scope :language, ->(id) { where(id: Feature.find(id).program_ids) }
  # scope :platform            , ->(id) { where id: Feature.find(id).programs.pluck(:id) }
  # scope :function            , ->(id) { where id: Feature.find(id).programs.pluck(:id) }
  # scope :read_format         , ->(id) { eager_load(:platforms, :resource_types, :resources, :read_image_formats).where(read_image_formats: {id: id}) }
  # scope :function            , ->(id) { eager_load(:resource_types, :resources, :platforms, :functions).where(features: {id: id}) }
  # scope :function            , ->(id) { includes(:resource_types, :resources, :functions).where(features: {id: id}) }
  # scope :for_feature         , ->(id) { eager_load(:platforms, :resource_types, :resources).where(features: {id: id}) }
  # scope :platform         , ->(id) { includes(:platforms).where(platforms: {id: id}) }
  # scope :platform         , ->(id) { includes(:platforms).where(features: {id: id, category: "Platform"}).references(:features) }

  scope :author      , ->(id) { where id: Author.find(id).programs }
  scope :read_format , ->(id) { where id: ImageFormat.find(id).read_programs }
  scope :write_format, ->(id) { where id: ImageFormat.find(id).write_programs }
  # scope :for_feature , ->(id) { includes(:platforms, :languages).references(:platforms, :languages).where id: Feature.find(id).programs }
  scope :for_feature , ->(id) { where id: Feature.find(id).programs }
  class << self
    feature_scopes  = %i(display_function for_audience function header_function interface language)
    feature_scopes += %i(network_function other_function platform programming_function read_format speciality write_format)
    feature_scopes.each{ |scop| alias_method scop, :for_feature}
  end

  # scope :for_audience        , ->(id) { includes(:features).where(features: {category: 'Audience', id: id}) }
  scope :latest_added        , ->(n = 10) { active.imaging.where.not(add_date: nil).order(add_date: :desc).limit(n) }

  validates :name, presence: true

  def self.ransackable_attributes(auth_object = nil)
    super.concat %w(languages platforms functions)
  end

  def self.ransackable_scopes(auth_object = nil)
    %i(platform language interface function read_format write_format) +
      %i(other_function conversion_function display_function header_function network_function programming_function) +
      %i(speciality programming network author scale_ratings for_audience active imaging)
  end

  # def self.ransortable_attributes(auth_object = nil)
  #   super.concat %w(composite_rating)
  # end

  def self.calculate_ratings
    all.includes(:ratings).order(:name).each { |program| program.calculate_ratings }
  end

  def calculate_ratings
    rating_will_change!
    # logger.debug("*** id #{id} rating #{rating} ***")
    tot_rat = total_rating
    self.rating = tot_rat
    self.save!
    # logger.debug("*** id #{id} tot_rat #{tot_rat}, rating now #{rating} ***")
  end

  def formatted_rating
    sprintf("%3.1f", rating) if rating
  end

  def total_rating
    if overall_rating
      sum_rating, sum_weight = 0, 0
      Rating::RATING_TYPES.each do |rtype, rweight|
        if r = send("#{rtype}_rating")
          sum_rating += r.rating * rweight
          sum_weight += rweight
        end
      end
      total_rating = sum_rating.to_f / sum_weight.to_f
    else
      total_rating = 0.0
    end
    return total_rating
  end

  def rating_by(user_id)
    ratings = Rating.rating_of(id, user_id)
    (ratings.count > 0) ? ratings.first.rating : 0
  end

  def all_related_programs
    related_programs + relating_programs
  end

  def latest_version_string
    versions.published.latest.last.ver_str if versions.latest.count > 0
    # "XXXX  latest_version_string XXXX"
  end

  # Program records from the old DB have add_date; newer records have created_at
  #
  # @return [Date]

  def added_date
    (add_date or created_at.to_date)
  end

end
