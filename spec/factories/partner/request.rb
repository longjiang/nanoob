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
    state { Partner::Request.states.keys.sample  }
    
    factory :webform_partner_request do
      channel :webform
    end
    
    factory :email_partner_request do
      channel :email
    end
  end
end


