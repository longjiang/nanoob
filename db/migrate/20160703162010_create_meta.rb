class CreateMeta < ActiveRecord::Migration[5.0]
  def change
    create_table :meta do |t|
      t.string  :metaable_type
      t.integer :metaable_id
      t.jsonb :datas, null: false, default: {}

      t.timestamps
    end
    add_index :meta, [:metaable_type, :metaable_id], unique: true
  end
end
