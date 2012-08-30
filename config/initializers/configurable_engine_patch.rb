Configurable.class_eval do 
  def self.keys
    self.defaults.collect { |k,v| k.to_s }
  end
end