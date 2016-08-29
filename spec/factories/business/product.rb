require 'faker'

FactoryGirl.define do
  factory :business_product, class: Business::Product do
    name { Faker::Lorem.word }
  end
end

