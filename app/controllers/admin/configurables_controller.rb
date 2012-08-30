class Admin::ConfigurablesController < Admin::BaseController
  include ConfigurableEngine::ConfigurablesController

  before_filter :set_view_variables

  def set_view_variables
    @title = t :configs
    @main_menu_active = 'configs'
  end
end
