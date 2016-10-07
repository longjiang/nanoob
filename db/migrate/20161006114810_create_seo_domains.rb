class CreateSeoDomains < ActiveRecord::Migration[5.0]
  def change
    create_table :seo_domains do |t|
      t.string :url
      t.integer :category, null:false, default: 0
      t.integer :links_count, null:false, default:0
      t.integer :anchors_count, null:false, default:0
      t.timestamps
    end
  end
end
