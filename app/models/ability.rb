class Ability
  include CanCan::Ability
  
  def initialize(user)
    user ||= User.new
    
    if user.has_role? "owner"
      can :manage, :all
    elsif user.has_role? "admin"
      can :manage, :cards
      can :manage, :users
    elsif user.has_role? "card_admin"
      can :manage, :cards
    else
      can :read, :cards
    end
  end
end