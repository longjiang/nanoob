require 'faker'

THREEDAYSAGO = DateTime.new(Time.now.year, Time.now.month, Time.now.day.eql?(3) ? -1 : Time.now.day - 3, 22, 30, 10)


FactoryGirl.define do
  
  factory :partner_backlink, class: Partner::Backlink do
    partner
    business
    association :owner, factory: :user
    referrer { Faker::Internet.url }
    anchor { Faker::Lorem.sentence(3) }
    link { Faker::Internet.url }
    status { Partner::Backlink.statuses.keys.sample }
    association :website, factory: :business_website
    
    factory :active_partner_backlink do
      status :active
      activated_at THREEDAYSAGO
    end
    
    factory :inactive_partner_backlink do
      status :inactive
      deactivated_at THREEDAYSAGO
    end
  end
end