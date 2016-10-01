class Blog::TaxonomyDecorator < ApplicationRecordDecorator
  delegate_all
  
  def public_url
    "#{permalink_prefix}#{object.slug}"
  end
  
  def name_with_tag
    "#{object.name} <span class='tag tag-#{object.posts.size.eql?(0) ? 'info' : 'success'}'>#{object.posts.size}</span>".html_safe
  end
  
  def permalink_prefix
    if object.website.present?
      "#{object.website.url}/#{taxonomy_slug}/"
    else
      ""
    end
  end
  

  
end