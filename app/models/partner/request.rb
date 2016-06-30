class Partner::Request < ApplicationRecord
  
  enum channel: [ :email, :webform ]
  #enum status: [ :draft, :sent, :canceled, :paid, :rejected, :in_progress, :accepted, :submitted, :published ]
  
  validates :state,              presence: true
  validates :partner_id,         presence: true
  validates :business_id,        presence: true
  validates :user_id,            presence: true
  
  belongs_to :partner,  counter_cache: true
  belongs_to :business
  belongs_to :owner,    class_name: 'User',  foreign_key: :user_id
  belongs_to :updater,  class_name: 'User',  foreign_key: :state_updated_by
  
  has_one :backlink,    class_name: 'Partner::Backlink',  foreign_key: :partner_request_id, :dependent => :nullify
  
  delegate :title, to: :partner, prefix: true
  delegate :name, to: :business, prefix: true
  delegate :username, to: :owner, prefix: true
  delegate :username, to: :updater, prefix: true
  
  before_save :default_values
  
  private
  
  def default_values
    self.state_updated_at ||= Time.now
  end
  
end
