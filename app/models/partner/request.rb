class Partner::Request < ApplicationRecord
  
  # include Bootsy::Container
  include AASM
  
  enum channel: [ :email, :webform ]
  enum state: [ :draft, :sent, :canceled, :paid, :rejected, :in_progress, :accepted, :submitted, :published ]
  
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
  
  attr_writer :body_xs

  def body_xs
    @body_xs ||= body
  end
  
  aasm :column => :state, :enum => true  do
    
    state :draft, initial: true
    state :sent, :canceled, :paid, :rejected, :in_progress, :accepted, :submitted, :published
    
    after_all_transitions Proc.new { self.state_updated_at = Time.now }
    
    event :send_request, after: :do_send_request, guard: :sendable? do
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
  
  private
  
  def do_send_request
    if email?
      # send email by owner
      logger.info "Sending email to #{partner.contact_name} <#{partner.contact_email}> with subject #{subject}"
    end
    self.sent_at = Time.now
  end
  
  def sendable?
    form_completed? && (webform? && partner_webform_valid? || email? && partner_contact_valid?)
  end
  
  def form_completed?
    subject.present? && body.present? && channel.present?
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
