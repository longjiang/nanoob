class Blog::Taxonomies::CategoryDecorator < Blog::TaxonomyDecorator
  
  def permalink_prefix
    if object.website.present?
      "#{object.website.url}/category/"
    else
      ""
    end
  end
  
end