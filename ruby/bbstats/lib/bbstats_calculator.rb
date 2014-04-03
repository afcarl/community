
module BBStats

  class Calculator

    attr_reader :options, :csv_loader

    def initialize(opts={})
      @options = opts
      @csv_loader = BBStats::CSVData.new
    end

    def calc_most_improved_avg
      puts "calc_most_improved_avg..."
    end

    def calc_slugging_pct_for_team
      puts "calc_slugging_pct_for_team..."
    end

    def identify_triple_crown_winner
      puts "identify_triple_crown_winner..."
    end

  end

end