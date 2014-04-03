module BBStats

  # This class is used to load the application data at runtime.  The current
  # data storage format is csv files, but this can be changed in this class,
  # in the future, to a relational or other database with no effect on the
  # rest of the system.

  class Datastore

    @@batters, @@pitchers, @@demographics = [], [], {}
    @@options, @@error = nil, nil
    @@batter_ids, @@batter_years = {}, {}

    def self.load(opts={})
      @@options = opts
      puts "Datastore.load; opts: #{opts.inspect}" if verbose?
      load_batting_data
      load_pitching_data
      load_demographic_data
      if verbose?
        puts "Datastore batters file:      #{@@options[:batting_csv]}"
        puts "Datastore batters size:      #{@@batters.size}"
        puts "Datastore demographics file: #{@@options[:demographic_csv]}"
        puts "Datastore demographics size: #{@@demographics.size}"
        puts "Datastore error?:            #{error?}"
        puts "Datastore error:             #{@@error.inspect}"
      end

      @@error
    end

    def self.batters
      @@batters
    end

    def self.pitchers
      @@pitchers
    end

    def self.demographics
      @@demographics
    end

    def self.batter_ids
      @@batter_ids
    end

    def self.sorted_batter_ids
      @@batter_ids.keys.sort
    end

    def self.batter_for_year(id, y)
      @@batter_years["#{id}:#{y}"]
    end

    def self.error?
      (@@error.nil?) ? false : true
    end

    def self.verbose?
      @@options[:verbose]
    end

    def self.lookup_player_demographic(id)
      @@demographics[id.to_s]
    end

    private

    def self.load_batting_data
      return if @@batters.size > 0
      read_csv_file(@@options[:batting_csv], :batter, 14)
    end

    def self.load_pitching_data
      # TODO - future enhancement
    end

    def self.load_demographic_data
      return if @@demographics.size > 0
      read_csv_file(@@options[:demographic_csv], :demographic, 4)
    end

    def self.read_csv_file(filename, data_type, expected_size)
      begin
        CSV.foreach(filename, :headers => true) do | row |
          if row && row.size == expected_size
            if data_type == :batter
              b = BBStats::Batter.new(row)
              @@batters << b
              @@batter_ids[b.player_id] = :exists
              @@batter_years[b.id_year_key] = b
            elsif data_type == :demographic
              id = row[0]
              @@demographics[id] = BBStats::Demographic.new(row)
            end
          else
            puts "Malformed row bypassed in file #{filename}: #{row.inspect}"
          end
        end
      rescue Exception => e
        puts "Exception in Datastore.read_csv_file - #{filename} - #{e.class.name} - #{e.message}"
        @@error = e
      end
    end

  end

end
