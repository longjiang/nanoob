class AddTypeToBlogPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :blog_posts, :type, :string
  end
end
