class Version < ActiveRecord::Base
  audited
  belongs_to :program

  # scope :latest3, -> { order("date desc").limit(3) }
  scope :latest         , ->(n = 1)  { where.not(date: nil).order("date desc").limit(n) }
  scope :latest_programs, ->(n = 10) { includes(:program).where.not(date: nil).order('date desc').first(n) }

  def ver_str
    "#{version} (#{date})"
  end

end
