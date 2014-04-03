module BBStats

  class CSVData

    attr_reader :batting_rows, :pitching_rows, :demographic_rows

    def initialize(opts={})
      @batting_rows, @pitching_rows, @demographic_rows = [], [], []
    end

    def load_batting_data

    end

    def load_pitching_data

    end

    def load_demographic_data

    end

  end

end
