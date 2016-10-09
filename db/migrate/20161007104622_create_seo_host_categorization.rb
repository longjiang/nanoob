class CreateSeoHostCategorization < ActiveRecord::Migration[5.0]
  def change
    create_table :seo_host_categorizations do |t|
      t.references :seo_host, foreign_key: true
      t.references :business, foreign_key: true
      t.integer :category, null: false, default: 2
      t.timestamps
    end
    add_index :seo_host_categorizations, [:seo_host_id, :business_id, :category], unique: true, name: 'index_host_categorizations_on_host_and_business_and_category'
  end
end
