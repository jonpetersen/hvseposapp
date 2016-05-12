#config = YAML.load_file(File.join(File.dirname(__FILE__), 'database.yml'))
config = YAML.load_file(File.join(File.dirname(__FILE__), 'database_rds.yml'))
env = DeploySetting.environment.to_s

ActiveRecord::Base.establish_connection(config[env])
ActiveRecord::Base.default_timezone = :utc
ActiveRecord::Base.include_root_in_json = false
