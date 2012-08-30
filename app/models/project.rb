class Project < ActiveRecord::Base

  attr_accessible :text, :title

  validates :title, :presence => true
  
end
