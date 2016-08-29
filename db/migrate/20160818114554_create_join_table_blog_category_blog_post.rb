class CreateJoinTableBlogCategoryBlogPost < ActiveRecord::Migration[5.0]
  def change
    create_join_table :blog_categories, :blog_posts do |t|
      t.index [:blog_category_id, :blog_post_id], unique: true, name: 'index_blog_categories_posts_on_category_id_and_post_id'
      # t.index [:blog_post_id, :blog_category_id]
      t.index [:blog_post_id]
    end
  end
end
