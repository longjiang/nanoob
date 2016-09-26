class AddTagsCountToBusinessWebsites < ActiveRecord::Migration[5.0]
  def change
    add_column :business_websites, :tags_count, :integer
  end
end
