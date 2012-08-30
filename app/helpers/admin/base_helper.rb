module Admin::BaseHelper
  def sortable(*args)
    options = args.extract_options!
    options[:column] = args[0]
    options[:title] = args[1]
    
    css_class = options[:column] == sort_column ? "current #{sort_direction}" : nil
    direction = options[:column] == sort_column && sort_direction == "asc" ? "desc" : "asc"
    
    parameters = {:sort => options[:column], :direction => direction, :per_page => per_page}
    parameters = parameters.merge(options[:params]) if options[:params] 
    link_to options[:title], parameters, {:class => css_class, :remote => options[:remote]}
  end
end
