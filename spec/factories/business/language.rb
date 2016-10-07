require 'faker'

FactoryGirl.define do
  factory :business_language, class: Business::Language do
    name { Faker::Lorem.word }
  end
end
