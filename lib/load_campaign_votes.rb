require 'csv'

module LogParser
  class LoadCampaignVotes

    DELIMITED_KEYS = %w(Campaign Validity CONN MSISDN GUID Shortcode)
    SQLITE3_INSERT_STMT = "INSERT INTO votes (vote_date, campaign, validity, choice) VALUES ("

    def initialize
      @errors = []
      @insert = []
    end

    def voted_at(data)
      # array position 1
      data[1]
    end

    def validity(data)
      # array position 3
      data[3].split(":").last
    end

    def campaign(data)
      # array position 2
      data[2].split(":").last
    end

    def choice(data)
      # array position 4
      choice = data[4].split(":")
      key = choice.first
      DELIMITED_KEYS.include?(key) ? "error" : choice.last
    end

    def readfile(filename)
      CSV.foreach(File.path(filename), encoding: "iso-8859-1:UTF-8") do |row|
        if (row[0].match /^VOTE \d{10,10} /)
          # create array of data to work with
          data = row[0].split
          choice = choice(data)
          if choice.match(/Choice|error/) || choice.nil?
            @errors << row[0]
          else
            @insert << "#{SQLITE3_INSERT_STMT} #{voted_at(data)}, '#{campaign(data)}', '#{validity(data)}', '#{choice}');"
          end
        end
      end
    end

    def errors
      puts "\n\nThe following errors were encountered. Please review"
      @errors.each {|error| puts error }
    end

    def write_files(file, type)
      f = File.open("tmp/#{file}", 'w')
      f.puts "# Output Type: #{type}"
      if type == 'error'
        f.puts @errors
      else
        f.puts @insert
      end
      f.close
    end
  end
end

a = LogParser::LoadCampaignVotes.new
a.readfile("data/votes.txt")
# only display errors if there are entries in the 'tmp/errors.txt' file
a.errors
a.write_files("insert_to_votes.txt", 'campaign votes')
a.write_files("errors.txt", 'error')
