class RenameTableBlogCategoriesToBlogTaxonomies < ActiveRecord::Migration[5.0]
  def change
    rename_table  :blog_categories, :blog_taxonomies
  end
end

