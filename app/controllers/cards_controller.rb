class CardsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  
  def index
    if params[:missing] == "true"
      @cards = Card.missing_images
    else
      @cards = Card.all
    end
  end

  def show
    @card = Card.find(params[:id])
  end

  def new
    @card = Card.new
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
end
