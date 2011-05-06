class CardlistsController < ApplicationController
  load_and_authorize_resource :except => ["add_card", "update_quantity", "update_title"]

  before_filter :authenticate_user!
  helper_method :sort_column, :sort_direction

  def show
    @cardlist = Cardlist.find(params[:id])
    authorize!(:show, @cardlist)

    respond_to do |format|
      format.pdf do
        @host_with_port = "#{request.protocol}#{request.host_with_port}"
        @host = "#{request.protocol}#{request.host}"
        render :pdf => "#{@cardlist.title}.pdf",
                :template => "cardlists/show.html.erb",
                :layout => "print.html",
                :page_size => "Letter",
                :dpi => 300,
                :margin => {:left => 4.5, :right => 4.5},
                :low_quality => false
      end
    end
  end

  def update_title
    @cardlist = Cardlist.find(params[:id])
    authorize!(:edit, @cardlist)
    preserve_params 

    @cardlist.update_attribute(:title, params[:value])

    respond_to do |format|
      format.js { render :text => @cardlist.title }
    end
  end

  def add_card
    @cardlist = Cardlist.find_by_id(params[:cardlist_id]) || Cardlist.create(:user_id => current_user.id)
    authorize!(:edit, @cardlist)
    preserve_params 

    @card = Card.find(params[:card_id])
    @cardlist.add_card(@card)

    respond_to do |format|
      format.js { render :layout => false }
    end
  end

  def update_quantity
    @cardlist_item = CardlistItem.find(params[:cardlist_item_id])
    authorize!(:edit, @cardlist_item)
    preserve_params 

    @cardlist_item.update_attribute(:quantity, params[:quantity]) if params[:quantity].to_i > 0
    @cardlist = @cardlist_item.cardlist
    respond_to do |format|
      format.js { render :layout => false }
    end
  end

end
