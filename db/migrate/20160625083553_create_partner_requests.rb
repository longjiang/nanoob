class CreatePartnerRequests < ActiveRecord::Migration[5.0]
  def change
    create_table :partner_requests do |t|
      t.references :partner,  foreign_key: true
      t.references :business, foreign_key: true
      t.integer    :owner_id
      t.string     :subject
      t.text       :body
      t.integer    :channel
      t.datetime   :sent_at
      t.integer    :state, null: false, default: 0
      t.datetime   :state_updated_at
      t.integer    :state_updated_by
      t.integer    :backlinks_count, default: 0

      t.timestamps
    end
    
    add_foreign_key :partner_requests, :people, column: :state_updated_by
    add_foreign_key :partner_requests, :people, column: :owner_id
  end
end
