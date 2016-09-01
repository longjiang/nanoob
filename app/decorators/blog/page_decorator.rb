class Blog::PageDecorator < Blog::PostDecorator
  
  def permalink_prefix
    if object.website.present?
      "#{object.website.url}/"
    else
      ""
    end
  end
  
  
  def self.icon
    'pagelines'
  end

end
