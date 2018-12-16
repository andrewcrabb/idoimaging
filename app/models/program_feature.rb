class ProgramFeature < ActiveRecord::Base
  belongs_to :program
  belongs_to :feature

end
