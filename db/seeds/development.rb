require 'faker'

# Update actual users
People::User.all.each do |u|
  u.password = 'secret'
  u.email = "#{u.username}@example.com"
  u.save(touch: false)
end

# add new users
%w(writer editor optimizer).each do |u|
  (1..3).each do |i|
    p = People::User.new(username: "#{u}#{i}", email: "#{u}#{i}@example.com", password: 'secret')
    p.add_role(:blogger)
    p.save
  end
end

# add Authors
5.times do
  People::Author.create!(username: Faker::Internet.user_name, firstname:Faker::Name.first_name, lastname:Faker::Name.last_name)
end


# websites

website1 = Business::Website.find_by_url('https://lapoigneedemain.com')
#website1.url = 'http://lapoigneedemain.com'
#website1.save(touch: false)

website2 = Business::Website.find_by_url('https://lemarchedurideau.com')
#website2.url = 'http://lemarchedurideau.com'
#website2.save(touch: false)

# Loading lemarchedurideau
#Rake::Task["db:data_migration:wp"].invoke('lemarchedurideau')

# randomize posts users
gilles = People::User.find_by_username('gilles')
david = People::User.find_by_username('david')
nanou = People::User.find_by_username('nanou')
ireti = People::User.find_by_username('ireti')

owners = [gilles, david, nanou]
writers = People::User.where('username like ?', "writer%") + [nanou, gilles]
editors = People::User.where('username like ?', "editor%") + [nanou, gilles]
optimizers = People::User.where('username like ?', "optimizer%") + [ireti]

print "updating posts users..."
Blog::Contents::Post.all.each do |p|
  p.owner = owners.sample
  p.writer = writers.sample
  p.editor = editors.sample
  p.optimizer = optimizers.sample
  p.save(touch: false)
end
puts " ok!"

# # Partners
# partner1 = Partner.new(owner: user1, title: 'Made in Design', url: 'http://madeindesign.com', contact_name: 'Guillaume', contact_email: 'guillaume_madeindesign@nanoob.com', webform_url: 'http://www.madeindesign.com/contact.html')
# partner1.decoration!
#
# partner2 = Partner.new(owner: user1, title: 'Second Bureau', url: 'http://secondbureau.com', contact_name: 'Gilles', contact_email: 'gilles@secondbureau.com')
# partner2.network_fr!
#
# # Requests
# request1 = Partner::Request.new(partner: partner1, business: business1, owner: user1, updater: user1, updated_at: Time.now, subject: '[Propulsion EC] Recherche de Partenariat', body: 'Je suis réellement tombé sous le charme de votre site internet....', state: 'published')
# request1.email!
#
# # Backlink
# backlink1 = Partner::Backlink.new(partner: partner1, business: business1, owner: user1, request: request1, referrer: 'http://www.madeindesign.com/mapage', anchor: 'rideau', link:'http://lemarchedurideau.com/')
# backlink1.active!
#
# backlink2 = Partner::Backlink.new(partner: partner2, business: business1, owner: user1, referrer: 'http://www.secondbureau.fr/fr/lagence', anchor: 'Co-fondateur & Directeur Général Asie', link: 'http://propulsionec.com/notre-equipe/')
# backlink2.active!
#
#
# # Random Data
#
# nbPartners = 500
# nbRequests = 900
#
#
#
#
#
#
# (1..nbPartners).each do |i|
#   date = Faker::Time.between(DateTime.now - 60, DateTime.now - 10)
#   p = Partner.new(title: Faker::Hipster.words(rand(3)+1).join(' ').humanize,
#                     category: Partner.categories.keys.sample,
#                     url: Faker::Internet.url,
#                     created_at: date,
#                     updated_at: date,
#                     owner:  People::User.all.sample
#                     )
#   if rand(100) > 50
#     p.contact_name = Faker::Name.name
#   end
#   if rand(100) > 50
#     p.contact_email = Faker::Internet.email
#   end
#   if rand(100) > 50
#     p.webform_url = Faker::Internet.url
#   end
#   puts "Partner #{i} created!"
#   p.save!
# end
#
#
# (1..nbRequests).each do |i|
#   staff =  People::User.all.sample
#   partner = Partner.all.sample
#   r = Partner::Request.new(partner: partner,
#                           business: Business.all.sample,
#                           owner: staff,
#                           updater: staff,
#                           subject: Faker::Lorem.sentence(5, true, 30),
#                           body: Faker::Lorem.paragraph(2),
#                           channel: Partner::Request.channels.keys.sample)
#   # draft
#   created_at = Faker::Time.between(partner.created_at, DateTime.now - 12.hours)
#   Timecop.travel created_at
#   r.state = :draft
#   r.save!
#
#   # sending
#   sent_at = Faker::Time.between(created_at, DateTime.now)
#   sending = false
#   if partner.is_valid_for_email_request?
#     r.channel = :email
#     sending = true
#   elsif partner.is_valid_for_webform_request?
#     r.channel = :webform
#     sending = true
#   end
#   if sending
#     Timecop.travel sent_at
#     r.updater =  People::User.all.sample
#     r.send_request
#   end
#
#   puts "Request #{r.id} created!"
# end
#
# Partner::Request.published.each do |request|
#
#   business = request.business
#
#   uri = URI(request.partner.url)
#   referrer_url = Faker::Internet.url(uri.host)
#
#   website = business.websites.sample
#   uri = URI(website.url)
#   link_url = Faker::Internet.url(uri.host)
#
#   created_at = Faker::Time.between(request.state_updated_at, DateTime.now - 2.day)
#
#   backlink = Partner::Backlink.create(partner: request.partner,
#               business: business,
#               owner:  People::User.all.sample,
#               request: request,
#               referrer: referrer_url,
#               anchor: Faker::Hipster.words(rand(3)+1).join(' '),
#               link: link_url,
#               created_at: created_at,
#               updated_at: created_at
#               )
#
#   if rand(100)<50
#     backlink.activated_at = Faker::Time.between(backlink.created_at, DateTime.now - 2.day)
#     backlink.active!
#     if rand(100)<50
#       backlink.deactivated_at = Faker::Time.between(backlink.activated_at, DateTime.now)
#       backlink.inactive!
#     end
#   end
# end

## Authors


