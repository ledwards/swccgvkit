module ApplicationHelper
  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = (column == sort_column) ? "current #{sort_direction}" : nil
    direction = (column == sort_column && sort_direction == "asc") ? "desc" : "asc"
    link_to title, card_params.merge(:direction => direction, :sort => column), {:class => css_class}
  end
  
  def controller_index
    params[:controller] == "home" ? "/" : "/#{params[:controller]}"
  end
  
  def card_params
    {
      :search => params[:search],
      :direction => params[:direction],
      :expansion => params[:expansion],
      :side => params[:side],
      :sort => params[:sort],
      :page => nil
    }
  end
end