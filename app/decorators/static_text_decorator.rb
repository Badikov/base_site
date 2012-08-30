class StaticTextDecorator < Draper::Base
  decorates :static_text

  def text
    static_text.text.to_s.html_safe
  end 
end
