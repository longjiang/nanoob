Metum.destroy_all
History.destroy_all
Blog::Post.destroy_all
Partner::Backlink.destroy_all
Partner::Request.destroy_all
Business::Product.destroy_all
Partner.destroy_all
Business.destroy_all
User.destroy_all
Dashboard::Period.destroy_all



# Periods
[[:today, "beginning_of_day", :daily, 1],
[:yesterday, "beginning_of_day - 1.day", :daily, 1],
[:this_week, "beginning_of_week", :weekly, 1],
[:last_week, "beginning_of_week - 1.week", :weekly, 1],
[:seven_last_days, "beginning_of_day - 6.days", :daily, 7]].each do |params|
  Dashboard::Period.create!(name: params[0], starts_at: params[1], cycle: params[2], cycles_count: params[3])
end
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
w = business1.websites.new(url: 'http://lemarchedurideau.com')
w.wordpress!
w = business1.websites.new(url: 'http://blog.lemarchedurideau.com')
w.blogger!

business2 = Business.find_by_name(b_name2)
w = business2.websites.new(url: 'http://lapoigneedemain.com')
w.wordpress!
w = business2.websites.new(url: 'http://blog.lapoigneedemain.com')
w.blogger!

business3 = Business.find_by_name(b_name3)
w = business3.websites.new(url: 'http://propulsionec.com')
w.wordpress!

# Partners
partner1 = Partner.new(owner: user1, title: 'Made in Design', url: 'http://madeindesign.com', contact_name: 'Guillaume', contact_email: 'guillaume_madeindesign@nanoob.com', webform_url: 'http://www.madeindesign.com/contact.html')
partner1.decoration!

partner2 = Partner.new(owner: user1, title: 'Second Bureau', url: 'http://secondbureau.com', contact_name: 'Gilles', contact_email: 'gilles@secondbureau.com')
partner2.network_fr!

# Requests
request1 = Partner::Request.new(partner: partner1, business: business1, owner: user1, updater: user1, updated_at: Time.now, subject: '[Propulsion EC] Recherche de Partenariat', body: 'Je suis réellement tombé sous le charme de votre site internet....', state: 'published')
request1.email!

# Backlink
backlink1 = Partner::Backlink.new(partner: partner1, business: business1, owner: user1, request: request1, referrer: 'http://www.madeindesign.com/mapage', anchor: 'rideau', link:'http://lemarchedurideau.com/')
backlink1.active!

backlink2 = Partner::Backlink.new(partner: partner2, business: business1, owner: user1, referrer: 'http://www.secondbureau.fr/fr/lagence', anchor: 'Co-fondateur & Directeur Général Asie', link: 'http://propulsionec.com/notre-equipe/')
backlink2.active!


# Random Data
require 'faker'
nbUsers = 3
nbPartners = 500
nbRequests = 900

(1..nbUsers).each do |i|
  User.create!(username: "user#{i}", email: "user#{i}@example.com", password: 'secret', password_confirmation: 'secret')
end

(1..nbPartners).each do |i|
  date = Faker::Time.between(DateTime.now - 60, DateTime.now - 10)
  p = Partner.new(title: Faker::Hipster.words(rand(3)+1).join(' ').humanize, 
                    category: Partner.categories.keys.sample,
                    url: Faker::Internet.url, 
                    created_at: date,
                    updated_at: date,
                    owner: User.all.sample
                    )
  if rand(100) > 50
    p.contact_name = Faker::Name.name
  end
  if rand(100) > 50
    p.contact_email = Faker::Internet.email
  end
  if rand(100) > 50
    p.webform_url = Faker::Internet.url
  end
  puts "Partner #{i} created!"
  p.save!
end


(1..nbRequests).each do |i|
  user = User.all.sample
  partner = Partner.all.sample
  r = Partner::Request.new(partner: partner, 
                          business: Business.all.sample, 
                          owner: user,
                          updater: user, 
                          subject: Faker::Lorem.sentence(5, true, 30), 
                          body: Faker::Lorem.paragraph(2),
                          channel: Partner::Request.channels.keys.sample)
  # draft
  created_at = Faker::Time.between(partner.created_at, DateTime.now - 12.hours)
  Timecop.travel created_at
  r.state = :draft
  r.save!
  
  # sending
  sent_at = Faker::Time.between(created_at, DateTime.now)
  sending = false
  if partner.is_valid_for_email_request?
    r.channel = :email
    sending = true
  elsif partner.is_valid_for_webform_request?
    r.channel = :webform
    sending = true
  end
  if sending
    Timecop.travel sent_at
    r.updater = User.all.sample
    r.send_request
  end
  
  puts "Request #{r.id} created!"
end
  
Partner::Request.published.each do |request|
  
  business = request.business
  
  uri = URI(request.partner.url)
  referrer_url = Faker::Internet.url(uri.host)
  
  website = business.websites.sample
  uri = URI(website.url)
  link_url = Faker::Internet.url(uri.host)
  
  created_at = Faker::Time.between(request.state_updated_at, DateTime.now - 2.day)
  
  backlink = Partner::Backlink.create(partner: request.partner, 
              business: business,
              owner: User.all.sample,
              request: request,
              referrer: referrer_url, 
              anchor: Faker::Hipster.words(rand(3)+1).join(' '), 
              link: link_url,
              created_at: created_at,
              updated_at: created_at
              )
  
  if rand(100)<50
    backlink.activated_at = Faker::Time.between(backlink.created_at, DateTime.now - 2.day)
    backlink.active!
    if rand(100)<50
      backlink.deactivated_at = Faker::Time.between(backlink.activated_at, DateTime.now)
      backlink.inactive!
    end
  end
end

