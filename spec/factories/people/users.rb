require 'faker'

FactoryGirl.define do
  
  password = Faker::Internet.password(6, 40)
  
  factory :user, class: People::User  do |f|
    f.email     { Faker::Internet.safe_email }
    f.username  { Faker::Internet.user_name }
    f.password  { password }
    
  end
end

