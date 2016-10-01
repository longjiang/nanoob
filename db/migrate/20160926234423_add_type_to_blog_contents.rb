class AddTypeToBlogContents < ActiveRecord::Migration[5.0]
  def change
    add_column :blog_contents, :type, :string
    add_index :blog_contents, :type
  end
end
