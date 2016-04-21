class Ability
  include CanCan::Ability

  def initialize(user)
    if user.has_role? :admin
      can :manage, :all
    elsif user.has_role? :edss
      cannot :manage, :sysadmin
      cannot :access, :rails_admin
      cannot :manage, :admin
    	can :manage, :edss
    else
      cannot :manage, :sysadmin
      cannot :access, :rails_admin    	
      cannot :manage, :edss
      cannot :manage, :admin
    end
  end
end
