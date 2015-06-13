module PocztaPolska
  class Office
    attr_reader :data

    def initialize(data)
      @data = data
    end

    def coordinates
      [@data[:szer_geogr].to_f, @data[:dl_geogr].to_f]
    end

    def address
      {
        street: @data[:ulica].to_s,
        number: @data.values_at(:nr_domu, :nr_lokalu).compact.join('/'),
        code: @data[:pna].to_s,
        town: @data[:miejscowosc].to_s
      }
    end

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
