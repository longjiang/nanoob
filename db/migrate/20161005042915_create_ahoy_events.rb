class CreateAhoyEvents < ActiveRecord::Migration
  def change
    create_table :ahoy_events do |t|
      t.integer :visit_id

      # user
      t.integer :user_id
      # add t.string :user_type if polymorphic
      
      t.references :business_website

      t.string :name
      t.jsonb :properties
      t.timestamp :time
    end

    add_index :ahoy_events, [:visit_id, :name]
    add_index :ahoy_events, [:user_id, :name]
    add_index :ahoy_events, [:business_website_id, :name]
    add_index :ahoy_events, [:name, :time]
  end
end
