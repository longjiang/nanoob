class CreateBusinesses < ActiveRecord::Migration[5.0]
  def change
    create_table :businesses do |t|
      t.string :name          , null: false
      t.string :product_line  , null: false
      t.integer :language      , null: false

      t.timestamps
    end
  end
end
