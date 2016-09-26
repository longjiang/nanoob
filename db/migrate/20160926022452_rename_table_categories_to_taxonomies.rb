class RenameTableCategoriesToTaxonomies < ActiveRecord::Migration[5.0]
  def change
    rename_table  :blog_categories, :blog_taxonomies
    rename_table  :blog_categories_posts, :blog_posts_taxonomies
    rename_column :blog_posts_taxonomies, :blog_category_id, :blog_taxonomy_id
    rename_index  :blog_posts_taxonomies, 'index_blog_categories_posts_on_category_id_and_post_id', 'index_blog_posts_taxonomies_on_post_id_and_taxonomy_id'
  end
end
