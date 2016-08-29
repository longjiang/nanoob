class CreateBlogPosts < ActiveRecord::Migration[5.0]
  def change
    create_table :blog_posts do |t|
      t.references  :business_website,  foreign_key: true
      t.integer     :owner_id
      t.integer     :editor_id
      t.integer     :writer_id
      t.string      :title
      t.string      :slug
      t.text        :body
      t.integer     :status
      t.datetime    :published_at
      t.integer     :comments_count, default: 0
      t.string      :featured_image_id
      t.integer     :categories_count, default: 0
      
      t.timestamps
    end
    
    add_index :blog_posts, :slug
    
    add_foreign_key :blog_posts, :people, column: :owner_id
    add_foreign_key :blog_posts, :people, column: :editor_id
    add_foreign_key :blog_posts, :people, column: :writer_id
    
  end
end
