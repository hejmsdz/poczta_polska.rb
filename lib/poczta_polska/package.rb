require 'poczta_polska/office'
require 'poczta_polska/event'

module PocztaPolska
  # The Package class contains all necessary information
  # about a tracked package.
  class Package
    # @return [Hash] Original data from the XML response
    attr_reader :data

    def initialize(data)
      @data = data
    end

    # @return [String] package ID
    def id
      @data[:numer].to_s
    end

    # @return [Symbol] package type code
    def type
      @data[:dane_przesylki][:kod_rodz_przes].to_sym
    end

    # @return [String] human-readable package type
    def type_str
      @data[:dane_przesylki][:rodz_przes].to_s
    end

    # @return [Symbol] origin country code
    def country_from
      @data[:dane_przesylki][:kod_kraju_nadania].to_sym
    end

    # @return [String] origin country name
    def country_from_str
      @data[:dane_przesylki][:kraj_nadania].to_s
    end

    # @return [Symbol] destination country code
    def country_to
      @data[:dane_przesylki][:kod_kraju_przezn].to_sym
    end

    # @return [String] destination country name
    def country_to_str
      @data[:dane_przesylki][:kraj_przezn].to_s
    end

    # @return [String] origin post office name
    def office_from
      @data[:dane_przesylki][:urzad_nadania][:nazwa].to_s
    end

    # @return [String] destination post office name
    def office_to
      @data[:dane_przesylki][:urzad_przezn][:nazwa].to_s
    end

    # @return [Float] mass of the package
    def mass
      @data[:dane_przesylki][:masa]
    end

    # @return [Boolean] whether the service has been finished (delivered, received in the post office, etc.)
    def ready?
      @data[:dane_przesylki][:zakonczono_obsluge]
    end

    # Returns detailed information about the origin post office,
    # only if the {Tracker#check}/{Tracker#check_many} method was called
    # with +details+ set to +true+.
    # @return [Office]
    def office_from_details
      office = @data[:dane_przesylki][:urzad_nadania][:dane_szczegolowe]
      Office.new(office) unless office.nil?
    end

    # Returns detailed information about the destination post office,
    # only if the {Tracker#check}/{Tracker#check_many} method was called
    # with +details+ set to +true+.
    # @return [Office]
    def office_to_details
      office = @data[:dane_przesylki][:urzad_przezn][:dane_szczegolowe]
      Office.new(office) unless office.nil?
    end

    # Returns a list of all events connected with the package
    # @return [Array<Event>]
    def events
      @data[:dane_przesylki][:zdarzenia][:zdarzenie].map { |e| Event.new(e) }
    end
  end
end
