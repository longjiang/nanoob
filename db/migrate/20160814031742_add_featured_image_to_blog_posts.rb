class AddFeaturedImageToBlogPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :blog_posts, :featured_image_id, :string
  end
end
