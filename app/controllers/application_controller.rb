class ApplicationController < ActionController::Base
  protect_from_forgery
  layout 'application'
  
  rescue_from CanCan::AccessDenied do |exception|
    flash[:alert] = exception.message
    redirect_to root_url
  end

  def preserve_params
    @search = params[:search]
    @direction = params[:direction]
    @sort = params[:sort]
    @side = params[:side]
    @expansion = params[:expansion]
  end
end
