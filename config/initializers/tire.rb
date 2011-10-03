rails_root = ENV['RAILS_ROOT'] || File.dirname(__FILE__) + '/../..'
rails_env = ENV['RAILS_ENV'] || 'development'

tire_config = YAML.load_file(rails_root + '/config/tire.yml')
Tire.configure do
  tire_config[rails_env].each do |key, value|
    send(key, value)
  end
end
