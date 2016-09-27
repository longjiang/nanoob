class RenameTableBlogPostsToBlogContents < ActiveRecord::Migration[5.0]
  def change
    rename_table  :blog_posts, :blog_contents
  end
end
