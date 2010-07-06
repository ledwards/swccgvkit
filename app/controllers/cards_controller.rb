class CardsController < ApplicationController
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
      redirect_to("/cards")
    else
      render :action => "new"
    end
  end

  def update
    @card = Card.find(params[:id])

    if @card.update_attributes(params[:card])
      flash[:notice] = 'Card was successfully updated.'
      redirect_to("/cards")
    else
      render :action => "edit"
    end
  end

  def destroy
  end

end
