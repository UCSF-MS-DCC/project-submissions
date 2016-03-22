class Ability
  include CanCan::Ability

  def initialize(user)

    if user.has_role? :admin
      can :manage, :all
    else
      cannot :manage, :sysadmin
      cannot :manage, :rails_admin
    end
  end
end
