module ApplicationHelper
  
  def page_title
    @page_title ||= @title
    @page_title.present? ? "#{strip_tags(@page_title)} | #{Configurable.site_name}".html_safe : Configurable.site_name
  end
  
  def specific_stylesheet_link_tag(side) 
    if File.exists?("#{Rails.root}/app/assets/stylesheets/#{side}/#{specific_stylesheet}.css.scss") || File.exists?("#{Rails.root}/app/assets/stylesheets/#{side}/#{specific_stylesheet}.css" )
     stylesheet_link_tag("#{side}/#{specific_stylesheet}")
    end
  end

  def specific_javascript_include_tag(side) 
    if File.exists?( "#{Rails.root}/app/assets/javascripts/#{side}/#{specific_javascript}.js") || File.exists?("#{Rails.root}/app/assets/javascripts/#{side}/#{specific_javascript}.js.coffee")   
     javascript_include_tag( "#{side}/#{specific_javascript}" )
    end
  end
  
end
