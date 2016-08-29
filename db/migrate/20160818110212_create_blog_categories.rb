class CreateBlogCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :blog_categories do |t|
      t.references :business_website, foreign_key: true
      t.integer :parent_id
      t.string :name
      t.string :slug
      t.integer :posts_count, default: 0

      t.timestamps
    end
    
    add_foreign_key :blog_categories, :blog_categories, column: :parent_id, primary_key: :id
  end
end
