class CreateHistories < ActiveRecord::Migration[5.0]
  def change
    create_table :histories do |t|
      t.string :object_class, null: false
      t.integer :object_id, null: false
      t.references :user, foreign_key: true
      t.timestamp :valid_from, null: false
      t.timestamp :valid_to, null: false
      t.integer :lock_version, default: 0, null: false
      t.jsonb :datas, null: false, default: {}
    end
  end
end
