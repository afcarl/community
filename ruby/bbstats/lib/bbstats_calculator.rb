
module BBStats

  class Calculator

    attr_reader :error

    def initialize(opts={})
      @error = BBStats::Datastore.load(opts)
    end

    def error?
      (error.nil?) ? false : true
    end

    def calc_most_improved_avg
      unless error?
        puts "calc_most_improved_avg..."
      end
    end

    def calc_slugging_pct_for_team
      unless error?
        puts "calc_slugging_pct_for_team..."
      end
    end

    def identify_triple_crown_winner
      unless error?
        puts "identify_triple_crown_winner..."
      end
    end

  end

end