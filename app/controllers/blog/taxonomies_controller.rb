class Blog::TaxonomiesController < CrudController
  
  self.permitted_attrs = [:business_website_id, :name, :slug, :hide_website_col]
  self.filtering_params = [:business_website_id ]
  self.sortable_attrs   = [ :name, :posts_count ]
  
  before_action :find_website
  skip_before_action :decorate_entry
  skip_before_action :entry, only: [:show]

  
  
end