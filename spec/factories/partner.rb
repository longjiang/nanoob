require 'faker'

FactoryGirl.define do
  
  factory :partner do
    title         { Faker::Lorem.word }
    category      { Partner.categories.keys.sample }
    url           { Faker::Internet.url }
    contact_name  { Faker::Name.name }
    contact_email { Faker::Internet.email }
    webform_url   { Faker::Internet.url }
    association :owner, factory: :user
    
  end
  
end

