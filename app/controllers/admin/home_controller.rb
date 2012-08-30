class Admin::HomeController < Admin::BaseController
  
  def login
    @title = t('users.login')
  end

  def index
    @title = t :admin_panel
  end
end
