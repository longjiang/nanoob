class CreatePartnerBacklinks < ActiveRecord::Migration[5.0]
  def change
    create_table :partner_backlinks do |t|
      t.references :partner,  foreign_key: true
      t.references :business, foreign_key: true
      t.references :business_website, foreign_key: true
      t.references :partner_request, foreign_key: true
      t.integer    :owner_id
      t.string     :referrer
      t.string     :anchor
      t.string     :link
      t.integer    :status
      t.datetime   :activated_at
      t.datetime   :deactivated_at

      t.timestamps
    end
    
    add_foreign_key :partner_backlinks, :people, column: :owner_id
    
  end
end
