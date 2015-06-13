module PocztaPolska
  # The Office class stores detailed information about
  # a particular post office.
  class Office
    # @return [Hash] Original data from the XML response
    attr_reader :data

    def initialize(data)
      @data = data
    end

    # Returns geographical coordinates of the post office.
    # @return [Array(Float, Float)] latitude and longitude
    def coordinates
      [@data[:szer_geogr].to_f, @data[:dl_geogr].to_f]
    end

    # Returns the address of the post office.
    # The keys in the hash are +:street+, +:number+, +:code+ and +:town+.
    # @return [Hash]
    def address
      {
        street: @data[:ulica].to_s,
        number: @data.values_at(:nr_domu, :nr_lokalu).compact.join('/'),
        code: @data[:pna].to_s,
        town: @data[:miejscowosc].to_s
      }
    end

    # Returns opening hours of the post office.
    # The keys in the hash are +:weekdays+, +:saturdays+ and +:sundays+ (including holidays).
    # Every value is an array in the format +[opening_hours, notes]+ or +nil+.
    # @return [Hash<Symbol => Array(String, String), nil>]
    def opening_hours
      hours = @data[:godziny_pracy]
      keys = {weekdays: :dni_robocze, saturdays: :soboty, sundays: :niedz_i_sw}
      Hash[
        keys.map do |h, x|
          value = unless hours[x].nil?
            [hours[x][:godziny].to_s, hours[x][:uwagi].to_s]
          end

          [h, value]
        end
      ]
    end
  end
end
