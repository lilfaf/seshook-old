class Ability
  include CanCan::Ability

  def initialize(user)
    @user = user || User.new

    if @user.superadmin?
      can :manage, :all
      can :manage, :sidekiq
    elsif @user.admin?
      can :manage, [Spot, Album, Photo, User]
    elsif @user.member?
      can :read, [Spot, Album, Photo, User]

      # user can create and search
      can [:search, :create], [Spot, Album, Photo]
      # user can edit or update his own account
      can [:update, :destroy], [Spot, User, Album], id: user.id
      # user can destroy his photos
      can :destroy, Photo, user_id: user.id
    end
  end
end
