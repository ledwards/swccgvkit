class Ability
  include CanCan::Ability
  
  def initialize(user)
    can :read, Card
    
    can :read, Cardlist do |cardlist|
      cardlist.user_id == user.id
    end
    can :edit, Cardlist do |cardlist|
      cardlist.user_id == user.id
    end
    can :create, Cardlist
    
    can :read, CardlistItem do |cardlist_item|
      cardlist_item.cardlist.user_id == user.id
    end
    can :edit, CardlistItem do |cardlist_item|
      cardlist_item.cardlist.user_id == user.id
    end
    can :create, CardlistItem
    
    can :add_card
    can :update_quantity
    
    if user.has_role? "admin"
      can :manage, Card
      can :manage, User
    end
    
    if user.has_role? "card_admin"
      can :manage, Card
    end
    
  end
end