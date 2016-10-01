require 'faker'

FactoryGirl.define do
   
  factory :post, class: Blog::Contents::Post  do |f|
    f.title { Faker::Lorem.word }
    association :website, factory: :business_website
    association :owner, factory: :user
  end

end

