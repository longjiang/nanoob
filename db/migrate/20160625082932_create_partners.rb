class CreatePartners < ActiveRecord::Migration[5.0]
  def change
    create_table :partners do |t|
      t.string  :title
      t.integer :category, null: false, default: 0
      t.string  :url
      t.string  :contact_name
      t.string  :contact_email
      t.string  :webform_url

      t.timestamps
    end
  end
end
