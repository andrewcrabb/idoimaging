class Version < ActiveRecord::Base
  audited
  belongs_to :program

  validates :date, presence: true

  # scope :latest3, -> { order("date desc").limit(3) }
  scope :latest         , ->(n = 1)  { where.not(date: nil).order("date desc").limit(n) }
  scope :latest_programs, ->(n = 10) { includes(:program).where.not(date: nil).order('date desc').first(n) }
  scope :published      , -> { where.not(published_on: nil) }
  scope :unpublished    , -> { where(published_on: nil) }

  def ver_str
    "#{version} (#{date})"
  end

  def unpublish
    published_on = nil
    save!
  end

end
