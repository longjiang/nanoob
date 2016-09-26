class Blog::Taxonomies::TagDecorator < Blog::TaxonomyDecorator
  
  def permalink_prefix
    if object.website.present?
      "#{object.website.url}/tag/"
    else
      ""
    end
  end
  
end