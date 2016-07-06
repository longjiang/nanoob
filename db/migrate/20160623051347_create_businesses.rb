class CreateBusinesses < ActiveRecord::Migration[5.0]
  def change
    create_table :businesses do |t|
      t.string  :name            , null: false
      t.references :business_product      , foreign_key: true
      t.integer :language        , null: false

      t.timestamps
    end
  end
end
