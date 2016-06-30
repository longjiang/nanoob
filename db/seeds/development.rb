Business::Product.destroy_all
Partner.destroy_all
Business.destroy_all
User.destroy_all

# Users
user1 = User.create!(username: 'admin', email: 'admin@example.com', password: 'secret', password_confirmation: 'secret')

# Business
b_name1 = 'Le Marché du Rideau'
b_name2 = 'La Poignée de Main'
b_name3 = 'Propulsion EC'
[[b_name1, 'curtains'], [b_name2, 'handles'], [b_name3, 'other']].each do |o|
  p = Business::Product.create!(name: o[1])
  b = Business.new(name: o[0], product: p)
  b.french!
end

# Business::Website
business1 = Business.find_by_name(b_name1)
w = business1.websites.new(url: 'https://lemarchedurideau.com')
w.wordpress!
w = business1.websites.new(url: 'http://blog.lemarchedurideau.com')
w.blogger!

business2 = Business.find_by_name(b_name2)
w = business2.websites.new(url: 'https://lapoigneedemain.com')
w.wordpress!
w = business2.websites.new(url: 'http://blog.lapoigneedemain.com')
w.blogger!

business3 = Business.find_by_name(b_name3)
w = business3.websites.new(url: 'https://propulsionec.com')
w.wordpress!

# Partners
partner1 = Partner.new(owner: user1, title: 'Made in Design', url: 'http://madeindesign.com', contact_name: 'Guillaume', contact_email: 'guillaume@madeindesign.com', webform_url: 'http://www.madeindesign.com/contact.html')
partner1.decoration!

partner2 = Partner.new(owner: user1, title: 'Second Bureau', url: 'http://secondbureau.com', contact_name: 'Gilles', contact_email: 'gilles@secondbureau.com')
partner2.network_fr!

# Requests
request1 = Partner::Request.new(partner: partner1, business: business1, owner: user1, updater: user1, updated_at: Time.now, subject: '[Propulsion EC] Recherche de Partenariat', body: 'Je suis réellement tombé sous le charme de votre site internet....', state: 'published')
request1.email!

# Backlink
backlink1 = Partner::Backlink.new(partner: partner1, business: business1, owner: user1, request: request1, referrer: 'http://www.madeindesign.com/mapage', anchor: 'rideau', link:'https://lemarchedurideau.com/')
backlink1.active!

backlink2 = Partner::Backlink.new(partner: partner2, business: business1, owner: user1, referrer: 'http://www.secondbureau.fr/fr/lagence', anchor: 'Co-fondateur & Directeur Général Asie', link: 'https://propulsionec.com/notre-equipe/')
backlink2.active!


# Random Data
require 'Faker'
nbUsers = 5
nbPartners = 70
nbRequests = 50

(1..nbUsers).each do |i|
  User.create!(username: "user#{i}", email: "user#{i}@example.com", password: 'secret', password_confirmation: 'secret')
end

(1..nbPartners).each do |i|
  date = Faker::Time.between(DateTime.now - 60, DateTime.now - 10)
  Partner.create!(title: Faker::Lorem.word, 
                    category: Partner.categories.keys.sample,
                    url: Faker::Internet.url, 
                    contact_name: Faker::Name.name, 
                    contact_email: Faker::Internet.email, 
                    webform_url: Faker::Internet.url,
                    created_at: date,
                    updated_at: date,
                    owner: User.all.sample
                    )
end

states = %w( draft sent canceled paid rejected in_progress accepted submitted published )
(1..nbRequests).each do |i|
  user = User.all.sample
  partner = Partner.all.sample
  p = Partner::Request.new(partner: partner, 
                          business: business1, 
                          owner: user,
                          updater: user, 
                          subject: Faker::Lorem.sentence(3), 
                          body: Faker::Lorem.paragraph(2) , 
                          channel: Partner::Request.channels.keys.sample,
                          state: states.sample)
 case p.state
   when 'draft'
     date = Faker::Time.between(partner.created_at, DateTime.now)
     p.state_updated_at = date
     p.created_at = date
     p.updated_at = date
   when 'sent'
     date = Faker::Time.between(partner.created_at, DateTime.now - 1)
     p.created_at = date
     sent_date = Faker::Time.between(date, DateTime.now)
     p.sent_at = sent_date
     p.state_updated_at = sent_date
     p.updated_at = sent_date
     p.updater = User.all.sample
   else
     date = Faker::Time.between(partner.created_at, DateTime.now - 5)
     p.created_at = date
     sent_date = Faker::Time.between(date, date + 2.day)
     p.sent_at = sent_date
     state_updated_at = Faker::Time.between(sent_date, DateTime.now)
     p.updated_at = state_updated_at
     p.state_updated_at = state_updated_at
     p.updater = User.all.sample
   end
   p.save!
end
  
