require 'poczta_polska/dynamic_reader'
require 'poczta_polska/office'

module PocztaPolska
  class Event
    attr_reader :data

    ATTR_MAP = {
      time: [:czas, lambda { |time| DateTime.parse(time) }],
      code: [:kod, :to_sym],
      name: [:nazwa, :to_s],
      office: [:jednostka, :nazwa, :to_s],
      final?: [:konczace, nil]
    }
    include DynamicReader

    def initialize(data)
      @data = data
    end

    def office_details
      office = @data[:jednostka][:dane_szczegolowe]
      Office.new(office) unless office.nil?
    end

    def reason
      {
        code: @data[:przyczyna][:kod].to_sym,
        name: @data[:przyczyna][:nazwa].to_s
      } unless @data[:przyczyna].nil?
    end
  end
end
