class CardsController < ApplicationController
  before_filter :authenticate_user!, :except => [:show, :index]
  load_and_authorize_resource
  skip_authorize_resource :only => [:show, :index]
  respond_to :html, :xml
  helper_method :sort_column, :sort_direction
  
  def index
    if request.format.symbol == :xml
      @cards = Card.all
    else
      @cards = Card.virtual.search(params[:search]).expansion(params[:expansion]).side(params[:side]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 20, :page => params[:page])
    end
    
    preserve_params
    respond_with @cards
  end

  def show
    @card = Card.find(params[:id])
    respond_with @card
  end

  def new
    @card = Card.new
    render :edit
  end

  def edit
    @card = Card.find(params[:id])
  end

  def create
    @card = Card.new(params[:card])

    if @card.save
      flash[:notice] = 'Card was successfully created.'
      redirect_to cards_path
    else
      redirect_to new_card_path
    end
  end

  def update
    @card = Card.find(params[:id])
    
    if @card.update_attributes(params[:card])
      flash[:notice] = 'Card was successfully updated.'
      redirect_to card_path(@card)
    else
      redirect_to cards_path
    end
  end

  def destroy
  end
  
  def sort_column
    Card.column_names.include?(params[:sort]) ? params[:sort] : "title"  
  end
    
  def sort_direction
    ["asc", "desc"].include?(params[:direction]) ? params[:direction] : "asc"
  end
end
