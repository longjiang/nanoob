require 'faker'

FactoryGirl.define do
  
  password = Faker::Internet.password(6, 40)
  
  factory :user, class: People::User  do |f|
    sequence(:email)     { |n| "#{n}#{Faker::Internet.safe_email}" }
    sequence(:username)  { |n| "#{Faker::Internet.user_name}#{n}" }
    f.password  { password }
    
    factory :admin do
      after(:create) do |user|
        user.add_role :admin
        user.save
      end
    end
    
    factory :editor do
      after(:create) do |user|
        user.add_role :editor
        user.save
      end
    end
    
    factory :blogger do
      after(:create) do |user|
        user.add_role :blogger
        user.save
      end
    end
    
  end
  

  
end

