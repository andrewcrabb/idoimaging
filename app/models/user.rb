class User < ActiveRecord::Base
  audited
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  has_many :ratings
  has_many :programs, through: :ratings

  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable,
    :confirmable

  before_create :default_role

  ADMIN  = 'admin'
  EDITOR = 'editor'
  USER   = 'user'

  ROLES = %i[ADMIN EDITOR USER]

  def role?(r)
    role and role.downcase.include? r.to_s.downcase
  end

  def admin?
  	role and role.downcase.eql? ADMIN.downcase
  end

  def editor?
  	role and [ADMIN, EDITOR].map{ |r| r.downcase.eql? role.downcase }.any?
  end

  private

  def default_role
    self.role ||= :user
  end

end
