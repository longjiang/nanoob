require 'faker'

FactoryGirl.define do
  
  factory :business do
    name          { Faker::Lorem.word }
    association :product, factory: :business_product 
    association :language, factory: :business_language
  end
end