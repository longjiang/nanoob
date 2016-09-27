class Blog::Contents::PostDecorator < Blog::ContentDecorator
  
  def permalink_prefix
    if object.website.present?
      "#{object.website.url}/#{object.year}/#{object.month}/"
    else
      ""
    end
  end
  
  def self.icon
    'thumb-tack'
  end
  
end