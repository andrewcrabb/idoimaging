class Author < ActiveRecord::Base
  has_many :author_programs, :dependent => :destroy
  has_many :programs, through: :author_programs
  has_many :resources, as: :resourceful

  accepts_nested_attributes_for :resources

  ATTRIBUTES = %i(name_last name_first institution email country)

  validate :has_last_name_or_institution

  def self.selector_values
    all.map{ |a| [a.common_name, a.id] }.sort{ |e, f| e[0].upcase <=> f[0].upcase }
  end

  def has_last_name_or_institution
    valid = !(name_last.nil? && institution.nil?)
    # puts "name_last #{name_last.to_s} (#{name_last.nil?.to_s}) institution #{institution.to_s} (#{institution.nil?.to_s}) valid #{valid}"
    errors.add(:base, "Last name and institution cannot both be nil") unless valid
  end

  def common_name(last_name_first = true)
    if name_last.length > 0
      (name_first.length > 0) ? last_name_first ? "#{name_last}, #{name_first}" : "#{name_first} #{name_last}" : name_last
    else
      institution
    end
  end

end
