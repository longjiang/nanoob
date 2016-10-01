class People::User < Person
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable, :registerable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable
  
  #validates_inclusion_of :time_zone, in: ActiveSupport::TimeZone.zones.map { |m| m.name }, message: 'is not a valid Time Zone'
  
  ROLES = %w(admin editor blogger webmaster)
  
  store_attribute :meta, :roles, Array, default: []
  
  has_many :requests,         class_name: 'Partner::Request',   foreign_key: :owner_id
  has_many :updated_requests, class_name: 'Partner::Request',   foreign_key: :state_updated_by
  has_many :backlinks,        class_name: 'Partner::Backlink',  foreign_key: :owner_id
  has_many :partners,         foreign_key: :owner_id
  has_many :histories
  has_many :posts,            class_name: 'Blog::Contents::Post', foreign_key: :owner_id
  has_many :edited_posts,     class_name: 'Blog::Contents::Post', foreign_key: :editor_id
  has_many :written_posts,    class_name: 'Blog::Contents::Post', foreign_key: :writer_id
  has_many :optimized_posts,  class_name: 'Blog::Contents::Post', foreign_key: :optimizer_id
  has_many :pages,            class_name: 'Blog::Contents::Page', foreign_key: :owner_id
  
  store_attributes :preferences do
    time_zone String, default: 'Beijing'
    owner_id Integer
    business_id Integer # favorite business
    business_manual Boolean, default: false  # set to true if user actually selected their favorite business
    business_updated_at DateTime, default: 1.year.ago
    website_id Integer #favorite website
    website_manual Boolean, default: false  # set to true if user actually selected their favorite business
    website_updated_at DateTime, default: 1.year.ago
    requests_weekly_goal Integer, default: 25
    requests_overview Array, default: [:seven_last_days, :this_week, :last_week]
    last_filters Hash, default: {}
  end
  
  def add_role role
    if ROLES.include?(role.to_s) && !roles.include?(role.to_s) && !roles.include?(role)
      self.roles = roles << role.to_s
    end
    roles
  end
  
  def remove_role role
    self.roles = roles - [role.to_s]
  end
  
  def has_role? role
    role = [role] unless role.is_a? Array
    (role & roles.map{|r| r.to_sym}).any?
  end

  def after_database_authentication
    init_preferences if sign_in_count.eql?(0)
  end
  
  def goal(period, object)
    if object.eql?(:request)
      if period.eql?(:weekly)
        requests_weekly_goal
      elsif period.eql?(:daily)
        requests_weekly_goal / 7
      end
    end
  end
  
  
  def init_preferences
    set_business
    set_website
    self.owner_id = id
    self.save
  end
  
  def set_business
    unless business_manual || business_updated_at > 5.days.ago
      business = Partner::Request.where(owner_id: id).where('created_at > ?', 10.days.ago).group(:business_id).count.sort_by{|id, count| count}
      unless business.blank?
        self.business_id = business.try(:last).try(:first) 
        self.business_updated_at = Time.now
      end
    end
  end
  
  def set_website
    unless website_manual || website_updated_at > 5.days.ago
      website = Blog::Contents::Post.where(owner_id: id).where('created_at > ?', 10.days.ago).group(:business_website_id).count.sort_by{|id, count| count}
      unless website.blank?
        self.website_id = website.try(:last).try(:first)
        self.website_updated_at
      end
    end
  end
end
