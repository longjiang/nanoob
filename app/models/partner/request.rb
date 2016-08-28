class Partner::Request < ApplicationRecord
  
  # include Bootsy::Container
  include AASM
  
  include Nanoob::History
  
  enum channel: [ :email, :webform ]
  enum state: [ :draft, :sent, :canceled, :paying, :rejected, :in_progress, :accepted, :paid, :submitted, :published ]
  
  validates :state,              presence: true
  validates :partner_id,         presence: true
  validates :business_id,        presence: true
  validates :owner_id,            presence: true
  
  belongs_to :partner,  counter_cache: true
  belongs_to :business,  counter_cache: true
  belongs_to :owner,    class_name: 'People::User',  foreign_key: :owner_id
  belongs_to :updater,  class_name: 'People::User',  foreign_key: :state_updated_by
  
  has_one :backlink,    class_name: 'Partner::Backlink',  foreign_key: :partner_request_id, :dependent => :nullify
  
  delegate :title, to: :partner, prefix: true
  delegate :name, to: :business, prefix: true
  delegate :username, to: :owner, prefix: true
  delegate :username, to: :updater, prefix: true
  
  scope :owner,         -> (staff)       { where owner: staff.to_i }
  scope :after,         -> (date)       { where 'sent_at >= ?', date }
  scope :before,        -> (date)       { where 'sent_at < ?', date }
  scope :channel,       -> (channel)    { where channel: channel }
  scope :state,         -> (state)      { where state: state }
  scope :recent,        -> (days)       { where("state_updated_at > ? ", days.to_i.days.ago) }
  scope :business_id,   -> (id)         { where business_id: id }
  
  after_create :init_history
  before_save :default_values
  
  attr_writer :body_xs

  def body_xs
    @body_xs ||= body
  end
  
  aasm :column => :state, :enum => true  do
    
    state :draft, initial: true
    state :sent, :canceled, :paying, :rejected, :in_progress, :accepted, :paid, :submitted, :published
    
    after_all_events :after_all_events
    
    event :send_request, after: :do_send_request, if: :sendable? do
      transitions from: :draft, to: :sent
    end
    
    event :cancel do
      transitions from: [:draft, :sent], to: :canceled
    end
    
   #event :receive
    
    event :submit do
      transitions from: [:draft, :sent], to: :submitted
    end
    
    event :publish do
      transitions from: [:draft, :sent], to: :published
    end

  end
  
  def form_completed?
    subject.present? && body.present? && channel.present?
  end
  
  def sendable?
    form_completed? && (webform? && partner_webform_valid? || email? && partner_contact_valid?)
  end

  
  private
  
  def init_history
    add_to_history({},{},"New request created", owner)
  end
  
  def after_all_events
    self.state_updated_at = Time.now
    add_to_history({state: aasm.from_state}, {state: aasm.to_state}, "event: #{aasm.current_event}", updater)
    self.save!
  end
  
  def do_send_request
    if email?
      PartnerRequestMailer.initial_request({request_id: self.id}).deliver
      logger.info "Sending email to #{partner.contact_name} <#{partner.contact_email}> with subject #{subject}"
    end
    
    self.sent_at = Time.now
  end
  
  
  
  
  
  def partner_contact_valid?
    partner.contact_email.present? && partner.contact_name.present?
  end
  
  def partner_webform_valid?
    partner.webform_url.present?
  end
  
  
  def default_values
    self.state_updated_at ||= Time.now # when initialized
  end

  def nilify_attributes
    %w(subject body)
  end
  
end
