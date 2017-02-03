class ProgramComponent < ActiveRecord::Base
  belongs_to :including_program, class_name: "Program"
  belongs_to :included_program , class_name: "Program"

  scope :component  , -> { where(kind: "component"  ) }
  scope :member     , -> { where(kind: "member"     ) }
  scope :related    , -> { where(kind: "related"    ) }
  scope :requirement, -> { where(kind: "requirement") }
end
