class CreateMeta < ActiveRecord::Migration[5.0]
  def change
    create_table :meta do |t|
      t.string :object_class
      t.integer :object_id
      t.jsonb :datas, null: false, default: {}

      t.timestamps
    end
  end
end
