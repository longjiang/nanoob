class AddAnchorsCountToBlogContents < ActiveRecord::Migration[5.0]
  def change
    add_column :blog_contents, :anchors_count, :integer, default: 0
  end
end
