source 'http://rubygems.org'

gem 'rails', '~>3.2.0'

gem "mongoid", "~> 3.0.0"
gem "devise", "~> 2.1.0"

gem "resque", require: "resque/server"
gem "nokogiri"
gem 'kaminari'
gem "tire"

group :assets do
  gem "jquery-rails"
  gem 'sass-rails', "  ~> 3.2.0"
  gem 'coffee-rails', "~> 3.2.0"
  gem "haml-rails", "~> 0.3.4"
  gem 'uglifier'
end

gem "rspec-rails", :group => [:development, :test]

group :test do
  gem "database_cleaner"
  gem "mongoid-rspec"
  gem "factory_girl_rails"
  gem "cucumber-rails"
  gem "capybara"
  gem "webmock"
end

group :development do
  gem 'nifty-generators'
end
