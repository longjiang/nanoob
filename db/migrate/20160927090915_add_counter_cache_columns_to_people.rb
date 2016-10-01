class AddCounterCacheColumnsToPeople < ActiveRecord::Migration[5.0]
  def change
    add_column :people, :edited_posts_count, :integer, default: 0
    add_column :people, :written_posts_count, :integer, default: 0
    add_column :people, :optimized_posts_count, :integer, default: 0
  end
end
