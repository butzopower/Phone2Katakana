require 'active_record'
require 'yaml'
require 'ruby-debug'
require 'rtranslate'

task :default => :migrate

desc "Migrate the database through scripts in db/migrate. Target specific version with VERSION=x"
task :migrate => :environment do
  ActiveRecord::Migrator.migrate('db/migrate', ENV["VERSION"] ? ENV["VERSION"].to_i : nil )
end

task :console => :environment do
  debugger
  puts "kinda like console"
end

task :environment do
  ActiveRecord::Base.establish_connection(YAML::load(File.open('config/database.yml')))
  ActiveRecord::Base.logger = Logger.new(File.open('logs/database.log', 'a'))
  Dir.glob(File.join(File.dirname(__FILE__), '/models/*.rb')).each {|f| require f }
end
