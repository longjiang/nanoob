class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  validates :username, presence: true
  
  has_many :requests,         foreign_key: :user_id
  has_many :updated_requests, foreign_key: :state_updated_by
  has_many :backlinks,        foreign_key: :user_id
  has_many :partners,         foreign_key: :user_id
  
  def time_zone
    'Beijing'
  end
  
end
