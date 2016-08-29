class CreateDashboardPeriods < ActiveRecord::Migration[5.0]
  def change
    create_table :dashboard_periods do |t|
      t.string :name
      t.string :starts_at
      t.integer :cycle
      t.integer :cycles_count

      t.timestamps
    end
  end
end
