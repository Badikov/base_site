class Front::PagesController < Front::BaseController
  
  def show
    path_array = request.path.split('/')
    path_array.shift(2)
    path = path_array.join('/')
    @text = StaticText.route_enabled.find_by_path(path) || not_found

    @title = @text.title

    set_meta_variables(@text)

    if @text.template.present?
      begin 
        render @text.template
      rescue ActionView::MissingTemplate => e
        render
      end
    else
      render
    end
  end

end
