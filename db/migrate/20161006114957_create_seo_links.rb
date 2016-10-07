class CreateSeoLinks < ActiveRecord::Migration[5.0]
  def change
    create_table :seo_links do |t|
      t.string :url
      t.references :seo_domain, foreign_key: true
      t.integer :level, null:false, default:2
      t.integer :anchors_count, null:false, default:0
      t.timestamps
    end
  end
end
