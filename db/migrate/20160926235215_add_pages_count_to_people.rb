class AddPagesCountToPeople < ActiveRecord::Migration[5.0]
  def change
    add_column :people, :pages_count, :integer
  end
end
