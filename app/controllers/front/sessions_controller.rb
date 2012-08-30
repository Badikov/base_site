class Front::SessionsController < Front::BaseController
  
  filter_access_to :all

  def new
    @title = t('users.login')
  end

  def create
    user = User.find_by_login_or_email(params[:login_or_email]) 
    
    session[:return_to] = params[:redirect_url] if params[:redirect_url].present?

    if user && user.active? && !user.banned? && user.authenticate(params[:password])

      if params[:remember_me] 
        cookies.permanent[:auth_token] = user.auth_token
      else
        cookies[:auth_token] = user.auth_token
      end
      session[:registration_complete] = nil if session[:registration_complete].present?

      redirect_back_or_default(params[:redirect_type] == 'backend' ? admin_root_url : user)
      
    else

      if user && user.banned?
        flash[:error] = t('users.banned')
      elsif user && !user.active?
        flash[:error] = t('users.not_active')
      else
        flash[:error] = t('users.login_failure')
      end
      
      redirect_to params[:redirect_type] == 'backend' ? admin_login_url : login_url
    end
  end

  def destroy  
    cookies.delete(:auth_token)
    redirect_to root_url
  end

end
