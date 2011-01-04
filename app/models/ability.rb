class Ability
  include CanCan::Ability
  
  def initialize(user)
    can :read, Card
    
    can :read, Cardlist#, :user_id => user.id
    can :edit, Cardlist#, :user_id => user.id
    can :create, Cardlist
    
    can :add_card
    
    if user.has_role? "admin"
      can :manage, Card
      can :manage, User
    end
    
    if user.has_role? "card_admin"
      can :manage, Card
    end
    
  end
end