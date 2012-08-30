module Front::BaseHelper

  def meta_description
    tag :meta, :name => 'description', :content => @meta_description.present? ? @meta_description : Configurable.meta_description
  end

  def meta_keywords
    tag :meta, :name => 'description', :content => @meta_keywords.present? ? @meta_keywords : Configurable.meta_keywords
  end

end
