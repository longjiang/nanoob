require 'faker'

FactoryGirl.define do
  
  factory :business do
    name          { Faker::Lorem.word }
    product_line  { Faker::Lorem.word }
    language      { Business.languages.keys.sample }
  end
end