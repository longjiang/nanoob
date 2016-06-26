class CreatePartnerRequests < ActiveRecord::Migration[5.0]
  def change
    create_table :partner_requests do |t|
      t.references :partner, foreign_key: true
      t.references :business, foreign_key: true
      t.references :user, foreign_key: true
      t.string    :subject
      t.text      :body
      t.integer   :channel
      t.datetime  :sent_at
      t.string    :state, null: false, default: 'draft'
      t.datetime  :state_updated_at
      t.integer   :state_updated_by

      t.timestamps
    end
    
    add_foreign_key :partner_requests, :users, column: :state_updated_by
  end
end
