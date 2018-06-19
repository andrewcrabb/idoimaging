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
    role and role.include? r.to_s
  end

  def admin?
  	role and role.eql? ADMIN
  end

  def editor?
  	role and [ADMIN, EDITOR].map{ |r| r.downcase }.include?(role.downcase)
  end

  private

  def default_role
    self.role ||= :user
  end

end
