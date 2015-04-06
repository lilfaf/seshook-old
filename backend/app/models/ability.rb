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

      can [:create], [Album, Photo]
      can [:search, :create], Spot
      # user can edit or update his own account
      can [:update, :destroy], [Spot, User, Album], id: user.id
    end
  end
end
