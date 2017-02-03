class Version < ActiveRecord::Base
  belongs_to :program

  # scope :latest3, -> { order("date desc").limit(3) }
  scope :latest, ->(n = 1) { order("date desc").limit(n) }

  def ver_str
    "#{version} (#{date})"
  end

end
