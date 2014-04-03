module BBStats

  class Demographic

    attr_reader :row

    @@field_name_indices = {
      :player_id  => 0,
      :birth_year => 1,
      :first_name => 2,
      :last_name  => 3
    }

    def initialize(row)
      # row contains these four fields: playerID,birthYear,nameFirst,nameLast
      @row = row
    end

    def player_id
      row[field_index(:player_id)]
    end

    def birth_year
      row[field_index(:birth_year)]
    end

    def first_name
      row[field_index(:first_name)]
    end

    def last_name
      row[field_index(:last_name)]
    end

    def full_name
      "#{first_name} #{last_name}"
    end

    private

    def field_index(field)
      @@field_name_indices[field]
    end

  end

end
