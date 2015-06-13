require 'poczta_polska/dynamic_reader'
require 'poczta_polska/office'

module PocztaPolska
  # The Event class stores information about a point
  # on the package's way.
  class Event
    # @return [Hash] Original data from the XML response
    attr_reader :data

    # Dynamic methods map
    # @see DynamicReader
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

    # Returns detailed information about the post office connected with this event,
    # only if the {Tracker#check}/{Tracker#check_many} method was called
    # with +details+ set to +true+.
    # @return [Office]
    def office_details
      office = @data[:jednostka][:dane_szczegolowe]
      Office.new(office) unless office.nil?
    end

    # Returns a reason of the event (available only for certain events
    # and certain users) or +nil+. The keys in the hash are +:code+ and +:name+.
    # @return [Hash]
    def reason
      {
        code: @data[:przyczyna][:kod].to_sym,
        name: @data[:przyczyna][:nazwa].to_s
      } unless @data[:przyczyna].nil?
    end
  end
end
