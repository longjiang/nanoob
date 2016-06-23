class CreateBusinesses < ActiveRecord::Migration[5.0]
  def change
    create_table :businesses do |t|
      t.string :name          , null: false, default: ""
      t.string :product_line  , null: false, default: ""
      t.integer :language      , null: false, default: 0

      t.timestamps
    end
  end
end
