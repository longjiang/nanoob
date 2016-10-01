class AddOptimizerIdToBlogContents < ActiveRecord::Migration[5.0]
  def change
    add_column :blog_contents, :optimizer_id, :integer
  end
end
