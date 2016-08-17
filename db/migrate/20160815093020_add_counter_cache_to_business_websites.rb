class AddCounterCacheToBusinessWebsites < ActiveRecord::Migration[5.0]
  def change
    add_column :business_websites, :backlinks_count, :integer, default: 0
    add_column :business_websites, :posts_count, :integer, default: 0
  end
end
