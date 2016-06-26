class Partner::Request < ApplicationRecord
  
  enum channel: [ :email, :webform ]
  #enum status: [ :draft, :sent, :canceled, :paid, :rejected, :in_progress, :accepted, :submitted, :published ]
  
  validates :state,         presence: true
  
  belongs_to :partner
  delegate :title, to: :partner, prefix: true
  
  belongs_to :business
  delegate :name, to: :business, prefix: true
  
  belongs_to :owner,    class_name: 'User',               foreign_key: :user_id
  delegate :username, to: :owner, prefix: true
  
  belongs_to :updater,  class_name: 'User',               foreign_key: :state_updated_by
  delegate :username, to: :updater, prefix: true
  
  has_one :backlink,    class_name: 'Partner::Backlink',  foreign_key: :partner_request_id, :dependent => :nullify
  
  before_save :default_values
  
  private
  
  def default_values
    self.state_updated_at ||= Time.now
  end
  
end
