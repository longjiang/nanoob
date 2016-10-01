class RenameTableBlogCategoriesPostsToBlogContentsTaxonomies < ActiveRecord::Migration[5.0]
  def change
    rename_table  :blog_categories_posts, :blog_contents_taxonomies
    rename_column :blog_contents_taxonomies, :blog_category_id, :blog_taxonomy_id
    rename_column :blog_contents_taxonomies, :blog_post_id, :blog_content_id
    rename_index  :blog_contents_taxonomies, 'index_blog_categories_posts_on_category_id_and_post_id', 'index_blog_contents_taxonomies_on_content_id_and_taxonomy_id'
  end
end
