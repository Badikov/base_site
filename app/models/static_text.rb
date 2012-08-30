class StaticText < ActiveRecord::Base

  attr_accessible :title, :path, :enable_route, :template, :text, :meta_description, :meta_keywords

  validates :title, :presence => true

  validates :path,  :presence => true,
                    :format => {:with => /\A[a-z\d]+[a-z\d\-_\/]*[a-z\d]+\z/i},
                    :uniqueness => {:case_sensitive => false}

  scope :route_enabled, where(:enable_route => true)

  before_save :squeeze_slashes_in_path

  def alias
    path.split('/').last
  end

  def squeeze_slashes_in_path
    self.path = path.squeeze('/')
  end

  def decorator
    StaticTextDecorator.new(self)
  end
end
