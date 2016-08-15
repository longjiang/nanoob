class CreateBlogPosts < ActiveRecord::Migration[5.0]
  def change
    create_table :blog_posts do |t|
      t.references  :business_website,  foreign_key: true
      t.references  :user,              foreign_key: true
      t.string      :title
      t.string      :slug
      t.text        :body
      t.integer     :status
      t.datetime    :published_at
      t.integer     :comments_count
      
      t.timestamps
    end
    
    add_index :blog_posts, :slug
    
  end
end
