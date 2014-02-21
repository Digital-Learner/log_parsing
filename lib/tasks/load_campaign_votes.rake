namespace :campaigns  do
  desc "generate data file for loading vote data"
  task :create_data_load_file, [:filename] => :environment do |t, args|
  	filename = args[:filename]
  	unless filename && File.exists?("#{Rails.root}/data/#{filename}")
  		puts "Filename required (must be located in application root/data directory)"
  		puts "Exiting" 
  		exit
  	end

  	load 'lib/load_campaign_votes.rb'

  	LogParser::LoadCampaignVotes.new(filename).main
  end

  desc "load vote data"
  task :load_vote_data, [:filename] => [:environment, :create_data_load_file] do |t, args|
  	filename = args[:filename]

  	dbconfig = YAML.load(File.read('config/database.yml'))
  	database = dbconfig[Rails.env]['database']

  	puts "\nImporting data from #{filename}..."
  	sh "sqlite3 #{database} < #{Rails.root}/tmp/insert_to_votes.sql"
  	puts "Completed loading #{filename} into #{Rails.env} environment."
  end
end