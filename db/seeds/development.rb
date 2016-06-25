Business.destroy_all
User.destroy_all

# Users
User.create!(username: 'admin', email: 'admin@example.com', password: 'secret', password_confirmation: 'secret')

# Business
[['Le Marché du Rideau', 'curtains'], ['La Poignée de Main', 'handles']].each do |o|
  b = Business.new(name: o[0], product_line: o[1])
  b.french!
end

# Business::Website
b = Business.find_by_product_line('curtains')
w = b.websites.new(url: 'https://lemarchedurideau.com')
w.wordpress!
w = b.websites.new(url: 'http://blog.lemarchedurideau.com')
w.blogger!

b = Business.find_by_product_line('handles')
w = b.websites.new(url: 'https://lapoigneedemain.com')
w.wordpress!
w = b.websites.new(url: 'http://blog.lapoigneedemain.com')
w.blogger!

