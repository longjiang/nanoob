class CreateSeoAnchors < ActiveRecord::Migration[5.0]
  def change
    create_table :seo_anchors do |t|
      t.string :text
      t.references :seo_link, foreign_key: true
      t.references :blog_content, foreign_key: true
      t.string :image_url

      t.timestamps
    end
  end
end
