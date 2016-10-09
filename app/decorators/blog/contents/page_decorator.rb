class Blog::Contents::PageDecorator < Blog::ContentDecorator
  
  def name
    object.title
  end
  
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
