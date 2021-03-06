class CreatePartners < ActiveRecord::Migration[5.0]
  def change
    create_table :partners do |t|
      t.string  :title
      t.integer :category
      t.string  :url
      t.string  :contact_name
      t.string  :contact_email
      t.string  :webform_url
      t.integer :requests_count, default: 0
      t.integer :backlinks_count, default: 0
      t.integer :owner_id, foreign_key: true

      t.timestamps
    end
    add_foreign_key :partners, :people, column: :owner_id
  end
end
