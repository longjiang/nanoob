source 'https://rubygems.org'

ruby "2.3.0"


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '>= 5.0.0.rc1', '< 5.1'
# Use postgresql as the database for Active Record
gem 'pg', '~> 0.18'
# Use Puma as the app server
gem 'puma', '~> 3.0'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5.x'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# views
gem 'haml'
gem 'bootstrap', '~> 4.0.0.alpha3.1'
gem "font-awesome-rails"
#gem 'bootstrap_form', :git => 'https://github.com/bootstrap-ruby/rails-bootstrap-forms'
gem 'bootstrap_form', :git => 'https://github.com/SecondBureau/rails-bootstrap-forms'
#gem 'bootstrap_form', :path => '/Users/gilles/Workspaces/rails-bootstrap-forms'
#gem 'draper', '~> 1.3'
gem 'draper', :git => 'https://github.com/drapergem/draper.git', :branch => 'rails-5'
gem 'select2-rails'
#gem 'bootsy'
gem 'bootsy', :git => 'https://github.com/volmer/bootsy.git', :branch => 'bootstrap-4'
gem 'kaminari'

gem 'resque'
gem 'resque_mailer', :git => 'https://github.com/SecondBureau/resque_mailer.git', :branch => 'rails5'
gem 'sinatra', github: 'sinatra/sinatra', branch: 'master'
gem "rack-protection", github: "sinatra/rack-protection"

# Attachments
gem 'refile', github: 'refile/refile', require: 'refile/rails'
gem 'refile-mini_magick', github: 'refile/refile-mini_magick'
gem 'php-serialize'

# Authentication
gem 'devise'

# activerecord
gem "validate_url"
gem "mysql2"
gem 'iconv'

# state machine
gem 'aasm'
#gem 'ruby-graphviz', :require => 'graphviz' # Optional: only required for graphing

# settings
#gem 'storext'
gem 'storext', :git => 'https://github.com/G5/storext.git'

# emails
gem 'postmark-rails', '>= 0.10.0'

source 'https://rails-assets.org' do
  gem 'rails-assets-tether', '>= 1.1.0'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  gem 'rspec-rails', '3.5.0.beta3'
  gem 'rails-controller-testing'
  gem 'faker', :require => false
  gem 'timecop'
  gem 'dotenv-rails'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  #gem 'guard-rspec', require: false
  gem 'rspec', '= 3.5.0.beta3'
  gem 'rspec-core', '= 3.5.0.beta3'
  gem 'rspec-expectations', '= 3.5.0.beta3'
  gem 'rspec-mocks', '= 3.5.0.beta3'
  gem 'rspec-support', '= 3.5.0.beta3'
  gem 'guard-rspec', '~> 4.7'
  gem 'guard-livereload', '~> 2.5', require: false
  gem 'growl'
  gem 'rdoc', '~> 4.2', '>= 4.2.2'
end

group :test do
  gem "codeclimate-test-reporter", require: nil
  gem 'simplecov', :require => false
  gem 'factory_girl_rails'
end

group :heroku do
  gem 'rails_12factor' # enable features such as static asset serving and logging on Heroku
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
