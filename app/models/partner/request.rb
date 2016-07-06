class Partner::Request < ApplicationRecord
  
  # include Bootsy::Container
  include AASM
  
  enum channel: [ :email, :webform ]
  enum state: [ :draft, :sent, :canceled, :paying, :rejected, :in_progress, :accepted, :paid, :submitted, :published ]
  
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
  
  scope :owner,         -> (user)       { where owner: user.to_i }
  scope :after,         -> (date)       { where 'sent_at >= ?', date }
  scope :before,        -> (date)       { where 'sent_at < ?', date }
  scope :channel,       -> (channel)    { where channel: channel }
  scope :state,         -> (state)      { where state: state }
  scope :recent,        -> (days)       { where("state_updated_at > ? ", days.to_i.days.ago) }
  scope :business_id,   -> (id)         { where business_id: id }
  
  before_save :default_values
  
  attr_writer :body_xs

  def body_xs
    @body_xs ||= body
  end
  
  aasm :column => :state, :enum => true  do
    
    state :draft, initial: true
    state :sent, :canceled, :paying, :rejected, :in_progress, :accepted, :paid, :submitted, :published
    
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
  
  def self.period(period)
    now = Time.zone.now
    case period
    when :today
      start_slice = now.beginning_of_day
      end_slice   = Time.now
    when :yesterday
      start_slice = now.beginning_of_day - 1.day
      end_slice = start_slice + 1.day
    when :two_days_ago
      start_slice = now.beginning_of_day - 2.day
      end_slice = start_slice + 1.day
    when :this_week
      start_slice = now.beginning_of_week
      end_slice = Time.now
    when :last_week
      start_slice = now.beginning_of_week - 7.day
      end_slice = start_slice + 7.days
    when :two_weeks_ago
      start_slice = now.beginning_of_day - 14.day
      end_slice = start_slice + 7.day
    end
    after(start_slice).before(end_slice)
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
