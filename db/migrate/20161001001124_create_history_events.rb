class CreateHistoryEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :history_events do |t|
      t.string :name
      t.string :description
      t.jsonb :datas
      t.timestamps
    end
    add_reference :histories, :history_event, foreign_key: true
  end
end
