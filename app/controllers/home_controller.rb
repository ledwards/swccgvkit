class HomeController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @cards = Card.virtual
    @cardlists = current_user.cardlists
    @current_cardlist = session[:current_cardlist_id] ? Cardlist.find(session[:current_cardlist_id]) : Cardlist.new
  end
  
  def about
  end
  
  def settings
  end
  
  def clear_current_cardlist
  end

end
