class Blog::TaxonomyDecorator < ApplicationRecordDecorator
  delegate_all
  
  def name_with_tag
    "#{object.name} <span class='tag tag-#{object.posts.size.eql?(0) ? 'info' : 'success'}'>#{object.posts.size}</span>".html_safe
  end
  
  def self.icon
    'list'
  end
  

  
end