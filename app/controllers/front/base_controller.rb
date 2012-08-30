class Front::BaseController < ApplicationController
  
  before_filter :is_site_enabled?
  before_filter :set_locale

  layout 'front/layouts/application'  
  
  def index
  
  end

  def set_meta_variables(item)
    @meta_description = item.meta_description
    @meta_keywords = item.meta_keywords
  end

  def is_site_enabled?
    unless (controller_name == 'sessions' && params[:redirect_type] == 'backend') || Configurable.site_enabled || (current_user && (current_user.admin? || current_user.super_admin?))
      return redirect_to root_url unless controller_name == 'base' && action_name == 'index'
      render :file => 'public/maintenance.html', :layout => nil
      return false
    end
  end

  def set_locale
    I18n.locale = params[:locale] if params[:locale].present? 
  end
  
  def default_url_options(options = {})
    {locale: I18n.locale}
  end
end
