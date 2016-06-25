require 'faker'

FactoryGirl.define do
  factory :business_website, class: Business::Website do
    business
    platform { Business::Website.platforms.keys.sample }
    url  { Faker::Internet.url }
  end
end

