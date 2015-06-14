require 'poczta_polska/office'

module PocztaPolska
  # The Event class stores information about a point
  # on the package's way.
  class Event
    # @return [Hash] Original data from the XML response
    attr_reader :data

    def initialize(data)
      @data = data
    end

    # @return [DateTime] date and time of the event
    def time
      DateTime.parse(@data[:czas])
    end

    # @return [Symbol] code of the event
    def code
      @data[:kod].to_sym
    end

    # @return [String] human-readable name of the event
    def name
      @data[:nazwa].to_s
    end

    # @return [String] name of the post office
    def office
      @data[:jednostka][:nazwa].to_s
    end

    # @return [Boolean] whether this is the final event (delivery, receiving in the post office, etc.)
    def final?
      @data[:konczace]
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
