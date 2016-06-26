Partner.destroy_all
Business.destroy_all
User.destroy_all

# Users
user1 = User.create!(username: 'admin', email: 'admin@example.com', password: 'secret', password_confirmation: 'secret')

# Business
[['Le Marché du Rideau', 'curtains'], ['La Poignée de Main', 'handles'], ['Propulsion EC', 'platform']].each do |o|
  b = Business.new(name: o[0], product_line: o[1])
  b.french!
end

# Business::Website
business1 = Business.find_by_product_line('curtains')
w = business1.websites.new(url: 'https://lemarchedurideau.com')
w.wordpress!
w = business1.websites.new(url: 'http://blog.lemarchedurideau.com')
w.blogger!

business2 = Business.find_by_product_line('handles')
w = business2.websites.new(url: 'https://lapoigneedemain.com')
w.wordpress!
w = business2.websites.new(url: 'http://blog.lapoigneedemain.com')
w.blogger!

business3 = Business.find_by_product_line('platform')
w = business3.websites.new(url: 'https://propulsionec.com')
w.wordpress!

# Partners
partner1 = Partner.new(title: 'Made in Design', url: 'http://madeindesign.com', contact_name: 'Guillaume', contact_email: 'guillaume@madeindesign.com', webform_url: 'http://www.madeindesign.com/contact.html')
partner1.decoration!

partner2 = Partner.new(title: 'Second Bureau', url: 'http://secondbureau.com', contact_name: 'Gilles', contact_email: 'gilles@secondbureau.com')
partner2.network_fr!

# Requests
request1 = Partner::Request.new(partner: partner1, business: business1, owner: user1, updater: user1, updated_at: Time.now, subject: '[Propulsion EC] Recherche de Partenariat', body: 'Je suis réellement tombé sous le charme de votre site internet....', state: 'published')
request1.email!

# Backlink
backlink1 = Partner::Backlink.new(partner: partner1, business: business1, owner: user1, request: request1, referrer: 'http://www.madeindesign.com/mapage', anchor: 'rideau', link:'https://lemarchedurideau.com/')
backlink1.active!

backlink2 = Partner::Backlink.new(partner: partner2, business: business1, owner: user1, referrer: 'http://www.secondbureau.fr/fr/lagence', anchor: 'Co-fondateur & Directeur Général Asie', link: 'https://propulsionec.com/notre-equipe/')
backlink2.active!