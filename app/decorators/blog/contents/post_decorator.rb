class Blog::Contents::PostDecorator < Blog::ContentDecorator
  
  ATTR_ICON_OPTIONS = {comments_count: 'comment-o', views_count: 'eye', anchors_count: 'link', words_count: 'asterisk' }
  
  def name
    title
  end
  
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
  
  def title(size=:xl)
    length = case size
    when :xs
      20
    when :sm
      40
    when :md
      50
    when :lg
      60
    else 
      120
    end
    h.truncate(ActionView::Base.full_sanitizer.sanitize(object.title), length: length, separator: length < 51 ? nil : /\s/, omission: '...')
    
  end
  
end