class Admin::BaseController < ApplicationController
  
  filter_access_to :all

  DEFAULT_PER_PAGE = 20
  before_filter :set_model
  before_filter :set_view_variables, :only => [:index, :show, :new, :create, :edit, :update]

  layout 'admin/layouts/application'
  
  helper_method :sort_column, :sort_direction, :per_page
  
  def index
    @items = @model.order(sort_column + " " + sort_direction).paginate(:per_page => per_page, :page => params[:page]) 
     @title = t(controller_name + '.pl')
  end
  
  def new
    @item = @model.new

    @title = "#{t(controller_name + '.pl')} &rarr; #{t :create}".html_safe
  end
  
  def create
    @item = @model.new(params[controller_name.singularize.to_sym], :without_protection => true)
    if @item.save
      flash[:success] = t :saved
      redirect_to after_save_redirect_url(@item)
    else
      flash.now[:error] = @item.valid? ? t(:save_failure_message) : t(:invalid_form_save_failure_message)
      @title = "#{t(controller_name + '.pl')} &rarr; #{t :create}".html_safe
      render 'new'
    end
  end
  
  def edit
    @item = @model.find(params[:id]) 
    @title = "#{t(controller_name + '.pl')} &rarr; #{t :edit}".html_safe
    render 'new'
  end
  
  def update
    @item = @model.find(params[:id])
    if @item.update_attributes(params[controller_name.singularize.to_sym], :without_protection => true)
      flash[:success] = t :saved
      redirect_to after_save_redirect_url(@item)
    else
      flash.now[:error] = @item.valid? ? t(:save_failure_message) : t(:invalid_form_save_failure_message)
      @title = "#{t(controller_name + '.pl')} &rarr; #{t :edit}".html_safe
      render 'new'
    end
  end
  
  def destroy
    @item = @model.find(params[:id])
     @item.destroy
    flash[:success] = t :deleted
    redirect_to index_url_from_controller_name
  end

  def per_page
    params[:per_page] && params[:per_page].to_i > 0 ? params[:per_page].to_i : DEFAULT_PER_PAGE
  end
  
  def sort_column
    if params[:sort]
      sort = @model.column_names.include?(params[:sort]) ? params[:sort] : default_sort
      session["admin_#{controller_name}_sort".to_sym] = sort
      sort
    else
      session["admin_#{controller_name}_sort".to_sym] ||= default_sort
    end
  end
  
  def sort_direction
    if params[:direction]
      direction = %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
      session["admin_#{controller_name}_sort_direction".to_sym] = direction
      direction
    else
      session["admin_#{controller_name}_sort_direction".to_sym] ||= "desc"
    end
  end
  
  def default_sort
    if @model.column_names.include?("name")
      "name"
    elsif @model.column_names.include?("title")
      "title"
    else
      "id"
    end  
  end
  
  def set_view_variables
    @main_menu_active = controller_name
  end
  
  def after_save_redirect_url(item)
    case params[:after_save_redirect]
      when 'new'
        eval("new_admin_#{controller_name.singularize}_url")
      else
        index_url_from_controller_name
    end
  end
  
  def index_url_from_controller_name
    eval(controller_name != controller_name.singularize ? "admin_#{controller_name}_url" : "admin_#{controller_name}_index_url")
  end
  
  def set_model
    begin
      @model = controller_name.singularize.camelize.constantize
    rescue
    
    end
  end  

  def permission_denied
    flash[:error] = current_user ? t('permissions.denied') : t('permissions.require_user')
    if current_user && permitted_to?(:admin, :index)
      url = admin_root_url
    elsif current_user
      url = root_url
    else
      url = admin_login_url
    end
    respond_to do |format|
      format.html{redirect_to url}
      format.js{render 'alert'}
    end 
  end
end
