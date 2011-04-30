class HomeController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @cards = Card.virtual.search(params[:search]).expansion(params[:expansion]).side(params[:side]).paginate(:per_page => 20, :page => params[:page])
    @cardlist = Cardlist.find_by_id(params[:cardlist_id]) || Cardlist.new
    @cards.first.try(:id) #this is here because of a very strange bug where the first element of @cards doesn't return its id the first time it's called

    preserve_params
  end
  
  def about
  end
  
  def settings
  end

end
