class AddPagesCountToBusinessWebsites < ActiveRecord::Migration[5.0]
  def change
    add_column :business_websites, :pages_count, :integer
  end
end
