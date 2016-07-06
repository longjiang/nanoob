class CreateBusinessWebsites < ActiveRecord::Migration[5.0]
  def change
    create_table :business_websites do |t|
      t.references :business, foreign_key: true
      t.integer :platform, null: false
      t.string :url, null: false

      t.timestamps
    end
  end
end
