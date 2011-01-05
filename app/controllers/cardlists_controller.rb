class CardlistsController < ApplicationController
  before_filter :authenticate_user!
  helper_method :sort_column, :sort_direction
  
  def create
  end
  
  def add_card
    @cardlist = Cardlist.find_by_id(session[:current_cardlist_id] || params[:cardlist_id]) || Cardlist.create(:user_id => current_user.id)
    authorize!(:edit, @cardlist)
    
    @card = Card.find(params[:card_id])
    @cardlist.add_card(@card)
    
    session[:current_cardlist_id] = @cardlist.id
    
    respond_to do |format|
      format.js { render :layout => false }
    end
  end
  
  def update_quantity
    @cardlist_item = CardlistItem.find(params[:cardlist_item_id])
    authorize!(:edit, @cardlist_item)

    @cardlist_item.update_attribute(:quantity, params[:quantity]) if params[:quantity].to_i > 0
    
    @cardlist = @cardlist_item.cardlist
    respond_to do |format|
      format.js { render :layout => false }
    end
  end
  
end