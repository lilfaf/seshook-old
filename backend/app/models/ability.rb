class Ability
  include CanCan::Ability

  def initialize(user)
    @user = user || User.new

    if @user.superadmin?
      can :manage, :all
      can :manage, :sidekiq
    elsif @user.admin?
      can :manage, [Spot, Album, Photo]
    elsif @user.member?
      can :read, [Spot, Album, Photo]
    end
  end
end
