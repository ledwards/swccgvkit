class CardsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  
  def index
    @cards = Card.all
  end

  def show
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
  
  def upload_vslip_image
  end

end
