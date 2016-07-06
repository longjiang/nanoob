require 'faker'

FactoryGirl.define do
  
  factory :business do
    name          { Faker::Lorem.word }
    association :product, factory: :business_product 
    language      { Business.languages.keys.sample }
  end
end