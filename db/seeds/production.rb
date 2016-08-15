# production

# Periods
[[:today, "beginning_of_day", :daily, 1],
[:yesterday, "beginning_of_day - 1.day", :daily, 1],
[:this_week, "beginning_of_week", :weekly, 1],
[:last_week, "beginning_of_week - 1.week", :weekly, 1],
[:seven_last_days, "beginning_of_day - 6.days", :daily, 7]].each do |params|
  Dashboard::Period.create!(name: params[0], starts_at: params[1], cycle: params[2], cycles_count: params[3])
end

# users
#SEED-USERS = '{"user1":{"e":"admin@example.com","p":"secret"},{"user2":{"e":"user2@example.com","p":"secret"}}'
users = ENV['SEED_USERS']
JSON.parse(users).each do |username, params|
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
