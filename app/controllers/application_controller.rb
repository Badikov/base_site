class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter { |c| Authorization.current_user = current_user }

  after_filter :clean_flash_if_xhr

  helper_method :current_user, :specific_stylesheet, :specific_javascript
  
  def current_user
    @current_user ||= User.where(:active => true, :banned => false).find_by_auth_token(cookies[:auth_token]) if cookies[:auth_token]
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  def clean_flash_if_xhr
    flash.discard if request.xhr?
  end

  def specific_stylesheet
    controller_name
  end
  
  def specific_javascript
    controller_name
  end

  def store_location
    session[:return_to] = request.url 
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to].present? ? session[:return_to] : default)
    session[:return_to] = nil
  end

  def permission_denied
    flash[:error] = current_user ? t('permissions.denied') : t('permissions.require_user')
    store_location unless current_user
    respond_to do |format|
      format.html{redirect_to current_user || login_url}
      format.js{render 'alert'}
    end 
    return false
  end

end
