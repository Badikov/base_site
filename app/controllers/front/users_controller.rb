class Front::UsersController < Front::BaseController
  
  filter_access_to :new, :create, :signup_complete, :activate, :forgot_password, :forgot_password_lookup_email, :reset_password, :reset_password_submit
  filter_access_to :edit, :update, :destroy, :attribute_check => true

  def index
    @users = User.all

    @title = t('users.pl')
  end

  def show
    @user = User.find(params[:id])

    @title = t('users.user_profile', :username => @user.login)
  end

  def new
    @user = User.new
    @title = t('users.signup')
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      if Configurable.confirm_registration
        @user.send_activation_instructions!   
        session[:registration_complete] = 'confirm'
      else
         @user.activate
         session[:registration_complete] = 'without_confirm'
      end
      redirect_to signup_complete_url
    else
      @title = t('users.signup')
      render 'new'
    end
  end

  def signup_complete
    not_found unless session[:registration_complete].present?
    @message = session[:registration_complete] == 'confirm' ? t('users.signup_with_confirm_complete') : t('users.signup_without_confirm_complete')
    @title = t('users.signup')
  end

  def activate
    user = User.find_using_perishable_token(params[:activation_code], 7.days) || not_found
    not_found if user.active?
    if user.activate
      flash[:success] = t('users.activation_complete')
      session[:registration_complete] = nil
      cookies[:auth_token] = user.auth_token
      redirect_to user
    else
      flash[:error] = t('failure.general')
      redirect_to root_url
    end
  end

  def edit
    @title = t('users.edit')
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:success] = t(:saved)
      redirect_to @user
    else
      flash[:error] = @user.valid? ? t('failure.general') : t('failure.invalid_form') 
      render 'edit'
    end
  end

  def destroy
    @user.destroy
    flash[:success] = t :deleted
    redirect_to root_url
  end

  def forgot_password   
    @title = t('users.reset_password')
  end

  def forgot_password_lookup_email
    user = User.find_by_email(params[:user][:email])
    if user
      user.reset_password_send!
      flash[:success] = "#{t('users.reset_password_sent', :email => user.email)}".html_safe
      respond_to do |format|
        format.html{redirect_to forgot_password_url}
        format.js{render}
      end  
    else
      flash[:error] = "#{t('users.email_not_found', :email => params[:user][:email])}".html_safe
      respond_to do |format|
        format.html{redirect_to forgot_password_url}
        format.js{render 'alert'}
      end  
    end
  end

  def reset_password
    @user = User.find_using_perishable_token(params[:reset_password_code], 7.days) || not_found
    @title = t('users.reset_password')
  end

  def reset_password_submit  
    @user = User.find_using_perishable_token(params[:reset_password_code], 7.days) || not_found
    if @user.update_attributes(params[:user])
      @user.reset_perishable_token!
      flash[:success] = t('users.reset_password_complete')
      redirect_to login_url
    else
      flash[:error] = t('failure.general')
      render 'reset_password'
    end
  end
end
