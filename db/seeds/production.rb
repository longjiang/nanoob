# production

# users
#SEED-USERS = '{"user1":{"e":"admin@example.com","p":"secret"},{"user2":{"e":"user2@example.com","p":"secret"}}'
users = ENV['SEED_USERS']
users.each do |username, params]
  User.create!(username: username, email: params['e'], password: params['p'], password_confirmation: params['p'])
end

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
w = business1.websites.new(url: 'https://blog.lemarchedurideau.com')
w.blogger!

business2 = Business.find_by_name(b_name2)
w = business2.websites.new(url: 'https://lapoigneedemain.com')
w.wordpress!
w = business2.websites.new(url: 'https://blog.lapoigneedemain.com')
w.blogger!

business3 = Business.find_by_name(b_name3)
w = business3.websites.new(url: 'https://propulsionec.com')
w.wordpress!
