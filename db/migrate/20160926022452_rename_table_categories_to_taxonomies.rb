class RenameTableCategoriesToTaxonomies < ActiveRecord::Migration[5.0]
  def change
    rename_table :blog_categories, :blog_taxonomies
    rename_table :blog_categories_posts, :blog_posts_taxonomies
    rename_column :blog_posts_taxonomies, :blog_category_id, :blog_taxonomy_id
  end
end
