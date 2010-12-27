class HomeController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @cards = Card.virtual.search(params[:search]).paginate(:per_page => 20, :page => params[:page])
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
