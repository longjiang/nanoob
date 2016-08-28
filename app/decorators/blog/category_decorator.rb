class Blog::CategoryDecorator < ApplicationRecordDecorator
  delegate_all
  
  def name_with_tag
    "#{object.name} <span class='tag tag-#{object.posts.size.eql?(0) ? 'info' : 'success'}'>#{object.posts.size}</span>".html_safe
  end
  
  def self.icon
    'list'
  end
  
  def permalink_prefix
    if object.website.present?
      "#{object.website.url}/category/"
    else
      ""
    end
  end
  
end