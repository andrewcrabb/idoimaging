class Ability
  include CanCan::Ability

  # Default way
  # def initialize(user)
  #   user ||= User.new # guest user
  #   if user.role == 'admin'
  #     can :manage, :all
  #   elsif user.role == 'editor'
  #     can :manage, [Program, Author, Resource]
  #     can :read, :all
  #   else
  #     can :read, :all
  #   end
  # end

  # https://goo.gl/0y64l
  def initialize(user)
    unless user
      # Guest User
      standard_rights
    else
      # All registered users
      # can {registered user-y permissions}
      case user.role
      when 'admin'
        can :manage, :all
      when 'editor'
        can :manage, [Program, Author, Resource]
      else
        standard_rights
        can :rating, [Program]
      end
    end
  end

  def standard_rights
    # can :read, [Program, Author, Resource]
    can :read, [Program]
    can :show, [Author, Resource]
    can :search, :all
  end

  def admin?
    user.role.to_s.upcase.eql? User::ADMIN.upcase
  end

  # def initialize(user)
  # Define abilities for the passed in user here. For example:
  #
  #   user ||= User.new # guest user (not logged in)
  #   if user.admin?
  #     can :manage, :all
  #   else
  #     can :read, :all
  #   end
  #
  # The first argument to `can` is the action you are giving the user
  # permission to do.
  # If you pass :manage it will apply to every action. Other common actions
  # here are :read, :create, :update and :destroy.
  #
  # The second argument is the resource the user can perform the action on.
  # If you pass :all it will apply to every resource. Otherwise pass a Ruby
  # class of the resource.
  #
  # The third argument is an optional hash of conditions to further filter the
  # objects.
  # For example, here the user can only update published articles.
  #
  #   can :update, Article, :published => true
  #
  # See the wiki for details:
  # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  # end
end
