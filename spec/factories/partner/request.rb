require 'faker'

FactoryGirl.define do
  factory :partner_request, class: Partner::Request do
    partner
    business
    association :owner, factory: :user
    subject { Faker::Lorem.sentence(3) }
    body { Faker::Lorem.paragraph(2) }
    channel { Partner::Request.channels.keys.sample }
    association :updater, factory: :user
  end
end


